class Make < ActiveRecord::Base
  validates :name, :presence => true

  attr_protected :all
  attr_accessible :name, :as => :admin
end
