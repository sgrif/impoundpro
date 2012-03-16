require 'spec_helper'

describe "PasswordResets" do
  let (:user) { create(:user) }
  subject { user }
  
  context "#create" do
    let(:create_request) do
      visit login_path
      click_link "Password"
      fill_in "Email", :with => email
      click_button "Reset Password"
      page
    end
    
    let(:email) { user.email }
    
    subject { create_request }
    
    context "with valid email" do   
      its("current_path") { should eq(login_path) }
      it { should have_content "Email sent" }
    end
    
    context "with invalid email" do
      let(:email) { "madeupemail@example.com" }
      
      its("current_path") { should eq(new_password_reset_path) }
      it { should have_content "No account found" }
    end
  end
  
  context "#update" do
    let(:update_request) do
      visit edit_password_reset_path(password_reset_token)
      fill_in "Password", :with => "newpassword"
      fill_in "Password confirmation", :with => "newpassword"
      click_button "Change Password"
      page
    end
    
    let(:password_reset_token) { user.password_reset_token }
    
    subject { update_request }
    
    context "with valid password_reset_token" do
      context "with token sent less than 2 hours ago" do
        before { user.send_password_reset }
        
        it { expect { update_request }.to change{user.reload.password_digest} }
        its("current_path") { should eq(login_path) }
        it { should have_content("Password has been reset") }
      end
      
      context "with token sent more than 2 hours ago" do
        let(:user) { create(:user, :password_reset_token => "anything", :password_reset_sent_at => 3.hours.ago) }
        
        it { expect { update_request }.not_to change{user.reload.password_digest} }
        its("current_path") { should eq(new_password_reset_path) }
        it { should have_content("Password reset has expired") }
      end
    end
  end
  
  context "#edit" do
    let(:edit_page) do
      visit edit_password_reset_path("nothing")
      page
    end
    
    subject { edit_page }
    
    it{ expect { edit_page }.not_to change{user.reload.password_digest} }
    its("current_path") { should eq(new_password_reset_path) }
    it{ should have_content("Invalid reset token") }
  end
end
