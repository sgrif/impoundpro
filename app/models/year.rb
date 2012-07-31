class Year < ActiveRecord::Base
  default_scope :order => "years.name DESC"

  has_many :cars
  has_and_belongs_to_many :models
  has_and_belongs_to_many :trims

  scope :by_trim, (lambda do |trim|
    ret = joins(:trims).where(['trims.id = ?', trim]) if trim
    return ret.nil? ? self.scoped : ret
  end)
end
