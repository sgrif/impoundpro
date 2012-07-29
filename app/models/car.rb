require 'decode_vin'
class Car < ActiveRecord::Base
  include DecodeVin

  #TODO Add in state boolean
  validates :year, :numericality => {:allow_blank => true}, :inclusion => {:in => 1900..Date.current.year + 2, :allow_blank => true}
  validates :state, :inclusion => {:in => States.keys, :message => "%{value} is not a valid state", :allow_blank => true}
  validates :vin,
    :presence => true,
    :uniqueness => { :scope => 'user_id', :message => "You already have a car with this VIN" },
    :length => { :in => 16..17 }

  validates :owner_state, :inclusion => {:in => States.keys, :message => "%{value} is not a valid state", :allow_blank => true}

  validates :lien_holder_state, :inclusion => {:in => States.keys, :message => "%{value} is not a valid state", :allow_blank => true}

  validates :driver_state, :inclusion => {:in => States.keys, :message => "%{value} is not a valid state", :allow_blank => true}

  validates :charge_hook_up, :numericality => {:greater_than_or_equal_to => 0}
  validates :charge_mileage, :numericality => {:greater_than_or_equal_to => 0}
  validates :charge_admin, :numericality => {:greater_than_or_equal_to => 0}
  validates :charge_other, :numericality => {:greater_than_or_equal_to => 0}
  validates :tax, :numericality => {:greater_than_or_equal_to => 0}

  validate :check_vin, :on => :create

  before_validation :ensure_tax_is_decimal, :ensure_vin_is_upcase
  before_create :decode_vin

  attr_accessor :charge_total, :charge_subtotal, :charges, :tax_amount, :override_check_vin
  attr_protected :stripe_invoice_item_token, :paid, :vin, :user_id

  belongs_to :user

  after_initialize :init

  def charge_subtotal
    self.charge_mileage + self.charge_storage + self.charge_admin + self.charge_hook_up + self.charge_other
  end

  def charge_total
    self.charge_subtotal * (self.tax + 1)
  end

  def charge_storage
    self.storage_rate * ((Date.today - date_towed.to_date).to_i + 1)
  end

  def tax_amount
    if self.tax > 0
      self.charge_total - self.charge_subtotal
    else
      0
    end
  end

  def charges
    vals = {
      "Hookup" => self.charge_hook_up,
      "Mileage" => self.charge_mileage,
      "Storage" => self.charge_storage,
      "Admininistration" => self.charge_admin,
      "Other" => self.charge_other,
      "Tax" => self.tax_amount
    }
    vals.delete_if{|key, value| value <= 0.0}
    vals
  end

  def check_vin
    if self.new_record? and !self.override_check_vin.present? and !self.errors.has_key?(:vin)
      sum = 0
      self.vin.chars.each_with_index do |c, i|
        if CheckVin[:char_trans][c].nil?
          errors.add :check_vin, "VINs should never contain character #{c}. Did you misread a numeric #{CheckVin[:misreads][c]}?"
          next
        else
          sum += (CheckVin[:char_trans][c] * CheckVin[:weights][i])
        end
      end
      check_digit = CheckVin[:char_trans][self.vin[8]]
      errors.add :check_vin, "VIN verification algorithm failed" if check_digit.nil? or sum % 11 != check_digit
    end
  end

  protected

  def init
    self.charge_hook_up           ||= 0.0
    self.charge_mileage           ||= 0.0
    self.charge_admin             ||= 0.0
    self.charge_other             ||= 0.0
    self.tax                      ||= 0.0
    self.storage_rate             ||= 0.0
    self.date_towed               ||= Date.today
    self.mail_notice_of_lien_date ||= Date.today
  end

  def decode_vin
    keep = ["year", "make", "model", "size", "state", "license_plate_number", "color"]
    new_attrs = Car.find_by_vin(self.vin).try(:attributes) || parse_vin(self.vin)
    new_attrs.keep_if { |k, v| keep.include?(k) }
    self.attributes = new_attrs
  end

  def ensure_tax_is_decimal
    if self.tax >= 1
      self.tax /= 100
    end
  end

  def ensure_vin_is_upcase
    self.vin = self.vin.upcase if self.new_record?
  end

end
