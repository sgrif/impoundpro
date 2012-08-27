class Year < ActiveRecord::Base
  default_scope order: "years.name DESC"

  has_many :cars
  has_and_belongs_to_many :models
  has_and_belongs_to_many :trims

  def to_s
    self.name
  end

  def self.by_trim(trim)
    if trim
      joins(:trims).where(trims_years: {trim_id: trim})
    else
      scoped
    end
  end
end
