require 'digest/sha2'

class User < ActiveRecord::Base
  #Allow changeable in state and out of state time limits for date of posting and date of auction
  validates :email, :presence => true, :uniqueness => true
  
  validates :name, :presence => true
  validates :address, :presence => true
  validates :city, :presence => true
  validates :state, :presence => true, :inclusion => {:in => States.keys, :message => "%{value} is not a valid state"}
  validates :zip, :presence => true
  
  validate :password_must_be_present
  
  validates :password, :confirmation => true
  attr_reader :password
  attr_accessor :password_confirmation
      
  before_create { generate_token(:auth_token) }
  
  has_many :cars, :dependent => :destroy
  
  def User.authenticate(email, password)
    if user = find_by_email(email)
      if user.hashed_password == encrypt_password(password, user.salt)
        user
      end
    end
  end
  
  def User.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + "wibble" + salt)
  end
  
  def password=(password)
    @password = password
    if hashed_password.present?
      UserMailer.password_changed(self).deliver
    end
    
    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
  end
  
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end
  
  def send_password_changed_notice
    UserMailer.password_changed(self).deliver
  end
  
  def save_with_payment
    if valid?
      save!
    end
  end
  
  private
  
  def password_must_be_present
    errors.add(:password, "Missing password") unless hashed_password.present?
  end
  
  def generate_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
  
  def generate_token(column)
    begin 
      self[column] = SecureRandom.hex(10)
    end while User.exists?(column => self[column])
  end
  
end
