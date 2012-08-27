class Trim < ActiveRecord::Base
  belongs_to :model
  has_many :cars
  has_and_belongs_to_many :years

  def to_s
    self.name
  end

  def self.by_year(year)
    if year
      joins(:years).where(:trims_years => {:year_id => year})
    else
      scoped
    end
  end
end
