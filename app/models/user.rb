require 'digest/sha2'

class User < ActiveRecord::Base
  #Allow changeable in state and out of state time limits for date of posting and date of auction
  validates :email, :presence => true, :uniqueness => {:scope => :email, :message => "There is already an account for email %{value}"}
  
  validates :name, :presence => true
  validates :address, :presence => true
  validates :city, :presence => true
  validates :state, :presence => true, :inclusion => {:in => States.keys, :message => "%{value} is not a valid state", :allow_blank => true}
  validates :zip, :presence => true
  validates :phone_number, :presence => true
  validates :county, :presence => true
    
  attr_protected :password_digest
  
  has_secure_password
      
  before_create { generate_token(:auth_token) }
  after_update :send_password_changed_notice
  
  has_many :cars, :dependent => :destroy, :order => "created_at DESC"
  
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end
  
  def send_password_changed_notice
    UserMailer.password_changed(self).deliver if self.password_digest_changed?
  end
  
  def welcome
    UserMailer.welcome(self).deliver
  end
  
  def save_with_payment
    if valid?
      save!
    end
  end
  
  private
  
  def generate_token(column)
    begin 
      self[column] = SecureRandom.hex(10)
    end while User.exists?(column => self[column])
  end
end
