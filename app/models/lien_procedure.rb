class LienProcedure < ActiveRecord::Base
  attr_accessible :car_id, :date_towed, :driver_address, :driver_city, :driver_name, :driver_state, :driver_zip, :tow_reason, :tow_requester

  belongs_to :car

  validates :active, uniqueness: {scope: :car_id, message: "This car already has an active lien procedure"}
end
