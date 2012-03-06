require 'digest/sha2'

class User < ActiveRecord::Base
  
  validates :email, :presence => true, :uniqueness => true
  
  validates :name, :presence => true
  validates :address, :presence => true
  validates :city, :presence => true
  validates :state, :presence => true, inclusion: {in: States.keys, message: "%{value} is not a valid state"}
  validates :zip, :presence => true
  
  validate :password_must_be_present
  
  validates :password, :confirmation => true
  attr_reader :password
  attr_accessor :current_password, :password_confirmation # Current password is used when changing passwords
  
  validate :authenticate_if_changing_password, on: :update
  
  attr_accessor :paypal_payment_token
  
  has_many :cars, dependent: :destroy
  
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
    
    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
  end
  
  def paypal
    PaypalPayment.new(self)
  end
  
  def save_with_payment
    if valid?
      response = paypal.make_recurring
      self.paypal_recurring_profile_token = response.profile_id
      save!
    end
  end
  
  def payment_provided? 
    paypal_payment_token.present?
  end
  
  private
  
  def password_must_be_present
    errors.add(:password, "Missing password") unless hashed_password.present?
  end
  
  def authenticate_if_changing_password
    errors.add(:current_password, "is incorrect") unless (User.authenticate(self.email, current_password) || password.empty?)
  end
  
  def generate_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
  
end
