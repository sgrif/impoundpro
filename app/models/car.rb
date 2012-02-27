#TODO Make tax have default
#TODO Validation
class Car < ActiveRecord::Base
  
  attr_accessor :charge_total
  
  belongs_to :user
 
  def charge_total
    return (self.charge_towing + self.charge_storage + self.charge_admin) * self.tax
  end
  
end
