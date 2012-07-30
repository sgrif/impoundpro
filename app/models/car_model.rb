class CarModel < ActiveRecord::Base
  belongs_to :make
  has_and_belongs_to_many :car_years
  has_many :car_trims
end
