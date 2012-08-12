class TowRecord < ActiveRecord::Base
  attr_accessible :car_id, :date_towed, :driver_address, :driver_city, :driver_name, :driver_state, :driver_zip, :tow_reason, :tow_requester

  belongs_to :car
end
