require 'spec_helper'

describe "PasswordResets" do
  it "emails users when requesting password reset" do
    user = Factory(:user)
    visit login_path
    click_link "Password"
    fill_in "Email", :with => user.email
    click_button "Reset Password"
    page.should have_content("Email sent")
    last_email.to.should include(user.email)
  end
end
