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

  alias_method :original_model, :model
  alias_method :original_year, :year

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
    year_id and make_id and model_id ? "#{year.name} #{make.name} #{model.name}" : "ID: #{vin}"
  end

  def model
    make.models.loaded? ? make.models.detect { |e| e.id = model_id } : original_model
  end

  def year
    self.model.years.loaded? ? self.model.years.detect { |e| e.id = year_id } : original_year
  end

  def status
    active_lien_procedure.nil? ? "inactive" : active_lien_procedure.status
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
