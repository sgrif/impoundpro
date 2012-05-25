require 'spec_helper'

describe UserMailer do
  let(:user) { Factory(:user, :password_reset_token => "anything") }

  describe "password_reset" do
    let(:mail) { UserMailer.password_reset(user) }

    it "sends user password reset url" do
      mail.subject.should eq("Password reset for impoundpro.com")
      mail.to.should eq([user.email])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should include(edit_password_reset_path(user.password_reset_token))
    end
  end

  describe "password_changed" do
    let(:mail) { UserMailer.password_changed(user) }

    it "sends user password changed notice" do
      mail.subject.should eq("impoundpro.com password changed")
      mail.to.should eq([user.email])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should include(new_password_reset_path(:email => user.email))
    end
  end

  describe "welcome" do
    let(:mail) { UserMailer.welcome(user) }

    it "sends user welcome" do
      mail.subject.should eq("Welcome to impoundpro.com")
      mail.to.should eq([user.email])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should include(login_path(:email => user.email))
    end
  end
end
