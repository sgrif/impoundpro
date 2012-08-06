class Trim < ActiveRecord::Base
  belongs_to :model
  has_many :cars
  has_and_belongs_to_many :years

  scope :by_year, (lambda do |year|
    ret = joins(:years).where(['years.id = ?', year]) if year
    return ret.nil? ? self.scoped : ret
  end)

  def to_s
    self.name
  end
end
