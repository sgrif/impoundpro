class Make < ActiveRecord::Base
  has_many :models
  has_many :years, :through => :models, :group => 'years.id'
end
