require 'spec_helper'

describe "Users" do
  before(:each) {@user = create(:user)}
  
  let(:user) {User.find_by_email(@user.email)}
  
  describe "registering" do   
    before(:each) do
      @params = attributes_for :user
      visit login_path
      click_link "Register"
    end
    
    let(:user) {User.find_by_email(@params[:email])}
    
    def request
      @params.each do |key, value|
        fill_in "user_#{key}", :with => value rescue {}
      end
      fill_in "user_password_confirmation", :with => @params[:password] if @params[:password] && !@params[:password_confirmation]
      select States[@params[:state]], :from => "user_state" if @params[:state]
      save_and_open_page if @stop
      click_button "Register"
    end
    
    context "with invalid fields" do
      before(:each) do
        @params[:email] = @user.email
        @params[:phone_number] = '764-4444'
      end
      
      describe "user count" do
        specify { lambda{request}.should_not change{User.count} }
      end
      
      describe "resulting page" do
        before { request }
        it "should not have emailed the user" do
          last_email.should be_nil
        end
        
        specify {current_path.should eq(user_path)}
        describe "errors" do it{all("#error_explanation li").should have_at_least(1).items} end
      end
    end
    
    context "with valid credentials" do  
      it "adds a new user" do
        expect { request }.to change{User.count}.by(1)
        user.should be
      end
      
      describe "resulting page" do
        before(:each) { request }
        it "should have emailed the user" do
          last_email.to.should include(@params[:email])
        end
        
        specify {current_path.should eq(login_path)}
        specify {page.should have_content("successfully created")}
      end
    end
  end
  
  describe "control panel" do
    subject { @user }
        
    before(:each) do 
      visit login_path
      fill_in "email", :with => @user.email
      fill_in "password", :with => @user.password
      click_button "Login"
      click_link "User"
    end
    
    context "when #update" do
      before(:each) do
        @params = attributes_for :user
        @params[:name] = "newname"
        @params[:address] = "newaddress"
      end
      
      def request
        @params.each do |key, value|
          fill_field "user_#{key}", value, page
        end
        click_button "Update"
      end
            
      context "without changed password" do
        before(:each) do
          @params[:password] = ""
          @params[:password_confirmation] = ""
          request
        end
                  
        it "should not email user" do
          last_email.should be_nil
        end
        
        its(:password_digest) { should eql(user.password_digest) }
        its(:name) { should_not eql user.name }
        
        describe "resulting page" do
          specify {current_path.should eq user_path}
          specify {page.should have_content "successfully updated"}
        end
      end
      
      context "with changed password" do
        before(:each) do
          @params[:password] = "newpass"
          @params[:password_confirmation] = "newpass"
          request
        end
        
        it "should email user" do
          last_email.to.should include(@user.email)
          last_email.subject.should eq 'impoundpro.com password changed'
        end
        
        its(:password_digest) { should_not eql user.password_digest }
                
        describe "resulting page" do
          specify {current_path.should eq user_path}
          specify {page.should have_content "successfully updated"}
        end
      end
    end
    
    context "when #destroy" do
      def request
        click_link "Cancel Account"
      end
      
      it "should delete user" do
        expect{request}.to change{User.count}.by(-1)
        user.should_not be
      end
      
      it "should delete auth cookie" do
        expect{request}.to change{Capybara.current_session.driver.request.cookies['auth_token']}.to(nil)
      end
      
      describe "resulting page" do
        before { request }
        
        specify { current_path.should eq login_path }
        specify { page.should have_content "account has been cancelled"}
      end
    end
  end
end
