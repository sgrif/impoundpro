#TODO CC Broken
require 'digest/sha2'

class User < ActiveRecord::Base
  #Allow changeable in state and out of state time limits for date of posting and date of auction
  validates :email, presence: true, uniqueness: { scope: :email, message: "There is already an account for email %{value}", allow_nil: true, allow_blank: true }, on: :create
  validates :name, presence: true
  validates :state, inclusion: {in: States.keys, message: "%{value} is not a valid state", allow_blank: true}

  attr_accessible :name, :address, :city, :state, :zip, :phone_number, :county, :password, :password_confirmation, :preparers_name, :stripe_card_token, :credit_card
  attr_accessible :name, :address, :city, :state, :zip, :phone_number, :county, :password, :password_confirmation, :preparers_name, :stripe_card_token, :credit_card, :email, as: :admin
  attr_accessor :stripe_card_token, :credit_card

  has_secure_password

  before_create { generate_token(:auth_token) }
  before_update :send_password_changed_notice

  has_many :cars, order: "created_at DESC"
  has_many :stripe_webhooks

  after_initialize {@credit_card = CreditCard.new}

  def trial_end_date
    2.weeks.since(self.created_at)
  end

  def trial_days_remaining
    (self.trial_end_date.to_date - Date.today).to_i
  end

  def has_subscription?
=begin TODO Optimize to use webhooks instead
    sub = Stripe::Customer.retrieve(self.get_stripe_customer_token).subscription
    !sub.nil? and sub.status == "active"
=end
    true
  end

  def needs_subscription?
    !self.has_subscription? && (self.trial_end_date.past? || self.cars.count > 5)
  end

  def profile_complete?
    !(self.address.blank? || self.city.blank? || self.state.blank? || self.zip.blank?)
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    #UserMailer.password_reset(self).deliver
  end

  def send_password_changed_notice
    #UserMailer.password_changed(self).deliver if password.present?
  end

  def welcome
    #UserMailer.welcome(self).deliver
  end

  def save_with_payment
    if valid?
      if stripe_card_token.present?
        self.add_subscription(stripe_card_token)
      end
      save!
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was an unexpected error. Please contact customer support."
    false
  rescue Stripe::CardError => e
    errors.add :base, e.message
    false
  end

  def update_with_payment(attributes, *args)
    options = args.extract_options!
    if self.update_attributes(attributes, options)
      self.save_with_payment
    end
  end

  def add_subscription(card)
    customer = Stripe::Customer.retrieve(get_stripe_customer_token)
    customer.update_subscription(:plan => "basic", card: card)
  end

  def get_stripe_customer_token
      unless self.stripe_customer_token
        customer = Stripe::Customer.create(:email => self.email)
        self.update_attribute(:stripe_customer_token, customer.id)
      end
      self.stripe_customer_token
  end

  def cancel
    customer = Stripe::Customer.retrieve(stripe_customer_token)
    customer.cancel_subscription
  end

  private

  def generate_token(column)
    begin
      self[column] = SecureRandom.hex(10)
    end while User.exists?(column => self[column])
  end
end

class CreditCard
  include ActiveAttr::Model
  attribute :number
  attribute :expiry, type: Date
  attribute :cvc

  def token
    Stripe::Token.create(
      card: {
        number: self.number,
        exp_month: self.expiry.month,
        exp_year: self.expiry.year,
        cvc: self.cvc
      }
    )
  end
end
