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
  
  describe "#create" do   
    let(:create_request) do
      visit login_path
      click_link "Register"
      fill_cc(credit_card_info, page)
      user_attributes.each do |key, value|
        fill_field "user_#{key}", value, page
      end
      click_button "Register"
      page
    end
    
    subject { create_request }
    
    context "with invalid fields" do
      let(:user_attributes) { attributes_for :user, :email => user.email, :password_confirmation => "" }
      
      it { lambda{ create_request }.should_not change(User, :count) }
      its("current_path") { should eq(user_path) }
      it { subject.all("#error_explanation li").should have_at_least(1).errors }
      it { should_not have_sent_email }
    end
    
    context "with valid fields" do 
      it { lambda { create_request }.should change(User, :count) }
      its("current_path") { should eq(login_path) }
      it { should have_content("successfully created") }
      it { should have_sent_email.to(user_attributes[:email]) }
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
