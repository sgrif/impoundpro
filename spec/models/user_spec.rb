require 'spec_helper'

describe User do
  let(:user) { create(:user, :stripe_customer_token => nil) }

  subject { user }

  context "validations" do
    it{ should validate_uniqueness_of(:email).with_message("There is already an account for email #{user.email}") }
    it "should validate presence of email on create" do
      @user = build(:user, :email => nil)
      @user.should have(1).error_on(:email)
      @user.should_not be_valid

      @user = user
      @user.email = nil
      @user.should have(0).errors_on(:email)
      @user.should be_valid
    end
    [:name, :address, :city, :state, :zip, :phone_number, :county].each { |field| it{ should validate_presence_of(field) } }
    [:password_digest, :created_at, :updated_at].each {|field| it{ should_not allow_mass_assignment_of(field) }}
  end

  describe '#authenticate' do
    context 'with valid credentials' do
      it { subject.authenticate(subject.password).should be }
    end

    context 'with invalid password' do
      it { subject.authenticate("madeuppassword").should_not be }
    end
  end

  describe '#send_password_reset' do
    it "generates a unique password_reset_token each time" do
      user.send_password_reset
      last_token = user.password_reset_token
      user.send_password_reset
      user.password_reset_token.should_not eq(last_token)
    end

    it "saves the time the password reset was sent" do
      user.send_password_reset
      user.reload.password_reset_sent_at.should be_present
    end

    it "delivers email to user" do
      user.send_password_reset
      last_email.to.should include(user.email)
    end
  end

  describe '#stripe_customer_token' do
    subject { user.reload.get_stripe_customer_token }
    it "should not change if present" do
      should eq user.reload.get_stripe_customer_token
    end
    it { should_not be_nil }
  end
end
