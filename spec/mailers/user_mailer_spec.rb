require 'spec_helper'

describe UserMailer do
  describe "password_reset" do
    let(:user) { Factory(:user, :password_reset_token => "anything") }
    let(:mail) { UserMailer.password_reset(user) }
    
    it "sends user password reset url" do
      mail.subject.should eq("Password reset for impoundpro.com")
      mail.to.should eq([user.email])
      mail.from.should eq(["from@example.com"])
    end
    
    it "renders the body" do
      mail.body.encoded.should match(edit_password_reset_path(user.password_reset_token))
    end
  end
end
