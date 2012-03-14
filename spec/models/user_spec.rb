require 'spec_helper'

describe User do
  let(:user) { Factory(:user) }
  
  describe '#authenticate_password' do
    context 'with valid credentials' do
      it 'authenticates successfully' do
        user.authenticate(user.password).should be_true
      end
    end
    
    context 'with invalid password' do
      it 'does not authenticate' do
        user.authenticate("madeuppassword").should_not be_true
      end
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