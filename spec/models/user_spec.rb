require 'spec_helper'

describe User do
  let(:user) { create(:user) }
  
  subject { user }
  
  it{ should validate_uniqueness_of(:email).with_message("There is already an account for email #{user.email}") }
  [:email, :name, :address, :city, :state, :zip, :phone_number, :county].each { |field| it{ should validate_presence_of(field) } }
  
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
end