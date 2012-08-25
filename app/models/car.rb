require 'decode_vin'
class Car < ActiveRecord::Base
  include DecodeVin

  validates :state, inclusion: {in: States.keys, message: "%{value} is not a valid state", allow_blank: true}
  validates :vin,
    presence: true,
    uniqueness: { scope: 'user_id', message: "You already have a car with this VIN" },
    format: { with: /^[A-Z0-9]*$/, message: "Only letters and number allowed" },
    on: :create # We can't change on update anyway

  validates :owner_state, inclusion: {in: States.keys, message: "%{value} is not a valid state", allow_blank: true}
  validates :owner_zip, numericality: {allow_blank: true}

  validates :lien_holder_state, inclusion: {in: States.keys, message: "%{value} is not a valid state", allow_blank: true}
  validates :lien_holder_zip, numericality: {allow_blank: true}

  validate :check_vin, on: :create

  before_validation :ensure_vin_is_upcase
  before_create :decode_vin

  attr_accessor :charge_total, :charge_subtotal, :charges, :tax_amount, :override_check_vin
  attr_protected :stripe_invoice_item_token, :paid, :vin, :user_id

  belongs_to :user
  belongs_to :make
  belongs_to :model
  belongs_to :year
  belongs_to :trim

  has_many :lien_procedures, dependent: :destroy
  has_one :active_lien_procedure, class_name: "LienProcedure", conditions: { active: true }

  accepts_nested_attributes_for :active_lien_procedure

  alias_method :original_model, :model
  alias_method :original_year, :year
  alias_method :original_active_lien_procedure, :active_lien_procedure

  def check_vin
    if self.new_record? and !self.override_check_vin.present? and !self.errors.has_key?(:vin)
      errors.add :check_vin, "VIN is not 17 digits" unless self.vin.length == 17
      sum = 0
      self.vin.chars.each_with_index do |c, i|
        if CheckVin[:char_trans][c].nil?
          errors.add :check_vin, "VINs should never contain character #{c}. Did you misread a numeric #{CheckVin[:misreads][c]}?"
          next
        else
          sum += (CheckVin[:char_trans][c].to_i * CheckVin[:weights][i].to_i)
        end
      end
      check_digit = CheckVin[:char_trans][self.vin[8]]
      errors.add :check_vin, "VIN verification algorithm failed" if check_digit.nil? or sum % 11 != check_digit
    end
  end

  def to_s
    (year_id and make_id and model_id) ? "#{year.name} #{make.name} #{model.name}" : "ID: #{vin}"
  end

  def model
    return nil if model_id.nil?
    make.models.loaded? ? make.models.detect { |e| e.id == model_id } : original_model
  end

  def year
    return nil if year_id.nil?
    self.model.years.loaded? ? self.model.years.detect { |e| e.id == year_id } : original_year
  end

  def active_lien_procedure
    lien_procedures.loaded? ? lien_procedures.detect { |e| e.active } : original_active_lien_procedure
  end

  def status
    if !active_lien_procedure.try('new_record?')
      active_lien_procedure.status
    elsif claimed?
      "claimed"
    elsif titled?
      "titled"
    else
      "inactive"
    end
  end

  def claimed? #TODO We'll need to differentiate between actually being claimed and being sold
    active_lien_procedure.nil? and lien_procedures.any?
  end

  def titled?
    active_lien_procedure.nil? and lien_procedures.any? and !claimed?
  end

  def self.with_ymm
    includes(:make, :model, :year)
  end

  def self.order_by_status
    includes(:lien_procedures).where(lien_procedures: {active: [true, nil]})
    .order "active, case
              when #{LienProcedure._action_required.to_sql} then 2
              when #{LienProcedure._action_soon.to_sql} then 1
              else 0 end desc".gsub(/\s+/," ").strip
  end

  protected

  def decode_vin
    keep = []
    new_attrs = Car.find_by_vin(self.vin).try(:attributes) || parse_vin(self.vin)
    new_attrs.keep_if { |k, v| keep.include?(k) }
    self.attributes = new_attrs
  end

  def ensure_vin_is_upcase
    self.vin = self.vin.upcase if self.new_record?
  end

end
