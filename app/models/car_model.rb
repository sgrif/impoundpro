class CarModel < ActiveRecord::Base
  belongs_to :car_make
  has_and_belongs_to_many :car_years
  has_many :car_trims
end
