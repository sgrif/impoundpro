class Car < ActiveRecord::Base
  
  #TODO What fields are optional?
  validates :year, :presence => true, :numericality => true, :inclusion => {:in => 1900..Date.current.year + 2}
  validates :make, :presence => true
  validates :model, :presence => true
  validates :size, :presence => true
  validates :color, :presence => true
  validates :state, :presence => true, :inclusion => {:in => States.keys, :message => "State %{value} is not a valid state"}
  validates :vin, :presence => true, :uniqueness => {:scope => :user_id, :message => "Car already exists with this VIN"}
  validates :license_plate_number, :presence => true, :uniqueness => {:scope => :user_id, :message => "Car already exists with this License Plate Number"}
  
  validates :owner_name, :presence => true
  validates :owner_address, :presence => true
  validates :owner_city, :presence => true
  validates :owner_state, :presence => true, :inclusion => {:in => States.keys, :message => "Owner State %{value} is not a valid state"}
  validates :owner_zip, :presence => true
  
  validates :lien_holder_state, :inclusion => {:in => States.keys, :message => "Lien Holder State %{value} is not a valid state", :allow_blank => true}
  
  validates :driver_state, :inclusion => {:in => States.keys, :message => "Lien Holder State %{value} is not a valid state", :allow_blank => true}
  
  validates :date_towed, :presence => true
  validates :tow_requested_by, :presence => true
  validates :tow_reason, :presence => true
  
  validates :charge_hook_up, :numericality => {:greater_than_or_equal_to => 0}
  validates :charge_mileage, :numericality => {:greater_than_or_equal_to => 0}
  validates :charge_storage, :numericality => {:greater_than_or_equal_to => 0}
  validates :charge_admin, :numericality => {:greater_than_or_equal_to => 0}
  validates :charge_other, :numericality => {:greater_than_or_equal_to => 0}
  validates :tax, :numericality => {:greater_than_or_equal_to => 0}
  
  before_validation :ensure_tax_is_decimal
  
  attr_accessor :charge_total, :charge_subtotal, :charges, :tax_amount
  
  belongs_to :user
  
  after_initialize :init
  
  def charge_subtotal
    self.charge_mileage + self.charge_storage + self.charge_admin + self.charge_hook_up + self.charge_other
  end
 
  def charge_total
    self.charge_subtotal * (self.tax + 1)
  end
  
  def charges
    vals = {
      "Hookup" => self.charge_hook_up,
      "Mileage" => self.charge_mileage,
      "Storage" => self.charge_storage,
      "Admininistration" => self.charge_admin,
      "Other" => self.charge_other,
      "Tax" => self.tax_amount}
    vals.delete_if{|key, value| value <= 0.0}
    vals
  end
  
  def tax_amount
    self.charge_total - self.charge_subtotal if self.tax > 0
  end
  
  protected
  
  def init
    self.charge_hook_up ||= 0.0
    self.charge_mileage ||= 0.0
    self.charge_storage ||= 0.0
    self.charge_admin   ||= 0.0
    self.charge_other   ||= 0.0
    self.tax            ||= 0
  end
  
  def ensure_tax_is_decimal
    if self.tax >= 1
      self.tax /= 100
    end
  end
  
end
