class Make < ActiveRecord::Base
  has_many :models
  has_many :years, through: :models, group: 'years.id'
  default_scope order('makes.name')

  scope :search, (lambda do |search|
    search ? where('makes.name ILIKE ?', "%#{search}%") : scoped
  end)

  def to_s
    self.name
  end
end
