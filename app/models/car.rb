#TODO Make tax have default
#TODO Validation
class Car < ActiveRecord::Base
  
  attr_accessor :charge_total, :charge_subtotal, :charges, :tax_amount
  
  belongs_to :user
  
  def charge_subtotal
    self.charge_mileage + self.charge_storage + self.charge_admin + self.charge_hook_up + self.charge_other
  end
 
  def charge_total
    self.charge_subtotal * self.tax + self.charge_subtotal
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
  
end
