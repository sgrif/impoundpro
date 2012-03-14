require 'spec_helper'

describe "PasswordResets" do
  before { @user = create(:user) }
  subject {@user}
  
  context "when requesting password reset" do
    def request(email)
      visit login_path
      click_link "Password"
      fill_in "Email", :with => email
      click_button "Reset Password"
    end
    
    context "with valid email" do
      before { request(@user.email) }
            
      it "should send email" do
        last_email.to.should include(@user.email)
      end
      
      describe "redirected page" do
        specify {current_path.should eq(login_path)}
        specify {page.should have_content("Email sent")}
      end
    end
    
    context "with invalid email" do
      before { request("madeupemail@example.com") }
      
      it "should not send email" do
        last_email.should be_nil
      end
      
      describe "redirected page" do
        specify {current_path.should eq(new_password_reset_path)}
        specify {page.should have_content("No account found")}
      end
    end
  end
  
  context "when submitting new password" do
    before { @params ||= {} }
    
    def request(params = {})
      @user.update_attributes(params)
      visit edit_password_reset_path(params[:password_reset_token])
      fill_in "Password", :with => "newpassword"
      fill_in "Password confirmation", :with => "newpassword"
      click_button "Change Password"
    end
    
    context "with valid password_reset_token" do
      before { @params[:password_reset_token] = "anything" }
      
      context "with token sent less than 2 hours ago" do
        before do
          @params[:password_reset_sent_at] = 1.hour.ago
          request(@params)
        end
        
        its(:password_digest) { should_not eql User.find_by_email(@user.email).password_digest }
        
        describe "redirected page" do
          specify {current_path.should eq(login_path)}
          specify {page.should have_content("Password has been reset")}
        end
        
        it "should email user" do
          last_email.to.should include(@user.email)
        end
      end
      
      context "with token sent more than 2 hours ago" do
        before do
          @params[:password_reset_sent_at] = 3.hours.ago
          request(@params)
        end
        
        its(:password_digest) { should eql User.find_by_email(@user.email).password_digest }
        
        describe "redirected page" do
          specify {current_path.should eq(new_password_reset_path)}
          specify {page.should have_content("Password reset has expired")}
        end
        
        it "should not email user" do
          last_email.should be_nil
        end
      end
    end
  end
  
  context "when accessing invalid token " do
    before { visit edit_password_reset_path "nothing" }
    
    its(:password_digest) { should eql User.find_by_email(@user.email).password_digest }
    
    describe "redirected page" do
      specify {current_path.should eq(new_password_reset_path)}
      specify {page.should have_content("Invalid reset token")}
    end
  end
end
