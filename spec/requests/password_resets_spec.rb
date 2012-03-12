require 'spec_helper'

describe "PasswordResets" do
  let(:user) { Factory(:user) }
  
  context "requesting password reset" do
    before(:each) do
      visit login_path
      click_link "Password"
      fill_in "Email", :with => email
      click_button "Reset Password"
    end
    
    context "with valid email" do
      let(:email) { user.email }
      
      it "sends email to user" do
        last_email.to.should include(user.email)
      end
      
      it "redirects to login" do
        current_path.should eq(login_path)
        page.should have_content("Email sent")
      end
    end
    
    context "with invalid email" do
      let(:email) { "madeupemail@example.com" }
      
      it "does not send email" do
        last_email.should be_nil
      end
      
      it "redirects to new password reset" do
        current_path.should eq(new_password_reset_path)
        page.should have_content("No account found")
      end
    end
  end
  
  context "submitting new password" do
    let(:user) { Factory(:user, :password_reset_token => "anything") }
    
    context "with valid password_reset_token" do
      before(:each) do
        visit edit_password_reset_path(user.password_reset_token)
        fill_in "Password", :with => "password"
        fill_in "Password confirmation", :with => "password"
        click_button "Change Password"
      end
      
      context "with token sent less than 2 hours ago" do
        let(:user) { Factory(:user, :password_reset_token => "anything", :password_reset_sent_at => 1.hour.ago) }
        
        it "changes password" do
          user.should eq(User.authenticate(user.email, "password"))
        end
        
        it "redirects to login" do
          current_path.should eq(login_path)
          page.should have_content("Password has been reset")
        end
        
        it "emails user" do
          last_email.to.should include(user.email)
        end
      end
      
      context "with token sent more than 2 hours ago" do
        let(:user) { Factory(:user, :password_reset_token => "anything", :password_reset_sent_at => 3.hours.ago) }
        
        it "does not change password" do
          user.should_not eq(User.authenticate(user.email, "password"))
        end
        
        it "redirects to new password reset" do
          current_path.should eq(new_password_reset_path)
          page.should have_content("Password reset has expired")
        end
        
        it "does not email user" do
          last_email.should be_nil
        end
      end
    end
    
    context "with unkown password_reset_token" do
      before(:each) do
        visit edit_password_reset_path("nothing")
      end
      
      it "should not change password" do
        user.should_not eq(User.authenticate(user.email, "password"))
      end
      
      it "redirects to new password reset" do
        current_path.should eq(new_password_reset_path)
        page.should have_content("Invalid reset token")
      end
    end
  end
end
