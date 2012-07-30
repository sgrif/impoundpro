class CarTrim < ActiveRecord::Base
  has_and_belongs_to_many :car_years
  belongs_to :car_model
end
