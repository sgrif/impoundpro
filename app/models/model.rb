class Model < ActiveRecord::Base
  belongs_to :make
  has_many :trims
  has_many :cars
  has_and_belongs_to_many :years

  def to_s
    self.name
  end
end
