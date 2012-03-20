require 'spec_helper'

describe "Users" do
  before(:each) { user }
  
  let(:user) { create :user }
  let(:user_attributes) { attributes_for :user }
  let(:credit_card_info) do
    {
      :card_number => card_number,
      :card_code => card_code,
      :card_month => card_month,
      :card_year => card_year
    }
  end
  let(:card_number) { "4242424242424242" }
  let(:card_code) { "123" }
  let(:card_month) { 3.months.since }
  let(:card_year) { 1.year.since }
  
  let(:login) do
    visit login_path
    fill_in "email", :with => user.email
    fill_in "password", :with => user.password
    click_button "Login"
    page
  end
  
  subject { login_page }
  
  describe "#new", :js => true do
    let(:new_page) do
      visit login_path
      click_link "Register"
      fill_cc(credit_card_info, page)
      page
    end
    
    subject { new_page }
    
    it "should change valid to invalid" do
      expect { fill_in "card_code", :with => "99" }.to change{subject.all("#credit_card_info .valid").count}.by(-1)
    end
    
    it "should check expiry on month change only when year is set" do
      expect { 
        select Date.today.year.to_s, :from => "card_year"
        select "1 - January", :from => "card_month"
      }.to change{subject.all("#credit_card_info .valid").count}.by(-1)
        
      expect {
        select "12 - December", :from => "card_month"
      }.to change{subject.all("#credit_card_info .valid").count}.by(1)
    end
    
    context "with valid cc info" do
      its("current_path") { should eq new_user_path }
      it { should_not have_xpath("//input[@type='submit' and @disabled='disabled']") }
      it { should have_css("#credit_card_info .valid", :count => 3) }
    end
    
    context "with cc problems" do
      shared_examples "js tests" do 
        its("current_path") { should eq new_user_path }
        it { should have_xpath("//input[@type='submit' and @disabled='disabled']") }
        it { should have_css("#credit_card_info .invalid", :count => 1) }
      end
      
      context "invalid card number" do
        let(:card_number) { "4242424242424241" }
        include_examples "js tests"
      end

      context "invalid cvc" do
        let(:card_code) { "99" }
        include_examples "js tests"
      end
      
      context "invalid expiry" do
        let(:card_month) { 1.month.ago }
        let(:card_year) { Date.today }
        include_examples "js tests"
      end
    end
  end
  
  describe "#create" do   
    let(:create_request) do
      visit login_path
      click_link "Register"
      user_attributes.each do |key, value|
        fill_field "user_#{key}", value, page
      end
      click_button "Register"
      page
    end
    
    let(:create_request_js) do
      visit login_path
      click_link "Register"
      fill_cc(credit_card_info, page)
      user_attributes.each do |key, value|
        fill_field "user_#{key}", value, page
      end
      click_button "Register"
      wait_until { page.has_content? ajax_result }
      page
    end
    
    subject { create_request }
    
    context "with invalid fields" do
      let(:user_attributes) { attributes_for :user, :email => user.email, :password_confirmation => "" }
      
      it { lambda{ create_request }.should_not change(User, :count) }
      its("current_path") { should eq(user_path) }
      it { subject.all("#error_explanation li").should have_at_least(1).errors }
      it { should_not have_sent_email }
      
      context "with valid cc info", :js => true do
        subject { create_request_js }
        
        let(:ajax_result) { "Payment info provided." }
        let(:card_number) { "4242424242424242" }
        
        it { lambda{ create_request_js }.should_not change(User, :count) }
        its("current_path") { should eq(user_path); }
        it { should have_content("Payment info provided.") }
      end
    end
    
    context "with valid fields" do
      it { lambda { create_request }.should change(User, :count) }
      its("current_path") { should eq(login_path) }
      it { should have_content("successfully created") }
      it { should have_sent_email.to(user_attributes[:email]) }
      
      context "with valid cc info", :js => true do
        subject { create_request_js }
        
        let(:ajax_result) { "Please Log In." }
        
        it { lambda { create_request_js }.should change(User, :count) }
        its("current_path") { should eq(login_path) }
        it { should have_content("successfully created") }
        it { should have_sent_email.to(user_attributes[:email]) }
        it { lambda { create_request_js }.should change(user, :stripe_customer_token){user.reload.stripe_customer_token} }
      end
      
      context "with invalid cc info", :js => true do
        subject { create_request_js }
        
        context "with invalid card number" do
          let(:card_number) { "4242424242424241" }
          let(:ajax_result) { "" }
          
          its("current_path") { should eq(new_user_path) }
          it { should have_xpath("//input[@type='submit' and @disabled='disabled']") }
          it { should have_css("#credit_card_info .invalid", :count => 1) }
          it { lambda { create_request_js }.should_not change(User, :count) }
          it { should_not have_sent_email}
        end
        
        context "declined card" do
          let(:card_number) { "4000000000000002" }
          let(:ajax_result) { "Your card was declined." }
          
          its("current_path") { should eq(new_user_path) }
          it { should have_no_xpath("//input[@type='submit' and @disabled='disabled']") }
          it { should have_no_css("#credit_card_info .invalid") }
          it { should have_content "Your card was declined." }
          it { lambda { create_request_js }.should_not change(User, :count) }
          it { should_not have_sent_email }
        end
      end
    end
  end
  
  describe "#update" do
    let(:update_request) do
      login
      click_link "User"
      user_attributes.each do |key, value|
        fill_field "user_#{key}", value, page
      end
      click_button "Update"
      page
    end
    
    subject { update_request }
    
    context "with new password" do
      context "with valid fields" do
        its("current_path") { should eq user_path }
        it { should have_content "successfully updated" }
        it { lambda { update_request }.should change(user, :attributes){user.reload.attributes} }
        it { lambda { update_request }.should change(user.reload, :password_digest){user.reload.password_digest} }
        it { should have_sent_email.to(user_attributes[:email]) }
      end
      
      context "with invalid fields" do
        let(:user_attributes) { attributes_for :user, :password_confirmation => '', :email => '' }
        
        its("current_path") { should eq user_path }
        it { subject.all("#error_explanation li").should have_at_least(1).errors }
        it { lambda { update_request }.should_not change(user, :attributes){user.reload.attributes} }
        it { lambda { update_request }.should_not change(user.reload, :password_digest) }
        it { should_not have_sent_email }
      end
    end
    
    context "without new password" do
      let(:user_attributes) { attributes_for :user, :password => '', :password_confirmation => '' }
      
      context "with valid fields" do
        its("current_path") { should eq user_path }
        it { should have_content "successfully updated" }
        it { lambda { update_request }.should change(user, :attributes){user.reload.attributes} }
        it { lambda { update_request }.should_not change(user.reload, :password_digest) }
        it { should_not have_sent_email }
      end
      
      context "with invalid fields" do 
        let(:user_attributes) { attributes_for :user, :password => '', :password_confirmation => '', :email => '' }
        
        its("current_path") { should eq user_path }
        it { subject.all("#error_explanation li").should have_at_least(1).errors }
        it { lambda { update_request }.should_not change(user, :attributes){user.reload.attributes} }
        it { lambda { update_request }.should_not change(user.reload, :password_digest) }
        it { should_not have_sent_email }
      end
    end
  end
  
  describe "#destroy" do
    let(:destroy_request) do
      login
      click_link "User"
      click_link "Cancel Account"
      page
    end
    
    subject { destroy_request }
    
    it { expect { destroy_request }.to change(User, :count).by(-1) }
    it { login; expect { destroy_request }.to change(nil, :auth_token){page.driver.request.cookies['auth_token']}.to(nil) }
    its("current_path") { should eq login_path }
    it { should have_content "account has been cancelled" }
  end
end
