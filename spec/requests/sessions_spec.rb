require 'spec_helper'

describe "Sessions" do
  let(:user) {create(:user)}

  let(:login) do
    visit login_path
    fill_in 'email', :with => user.email
    fill_in 'password', :with => user.password
    click_button 'Login'
    page
  end

  let(:logout) do
    login
    visit root_path
    click_link "Logout"
    page
  end

  describe "#new" do
    subject do
      visit login_path
      page
    end

    its("current_path") {should eq(login_path)}
    it{ subject.all('p#alert').should have(0).alerts }
    it{ subject.all('p#error').should have(0).errors }
    it{ subject.all('p#notice').should have(0).notices }
  end

  describe "#create" do
    subject { login }

    context "with valid credentials" do
      its("current_path"){ should eq(root_path) }
      it{ subject.all('p#alert').should have(0).alerts }
      it{ subject.all('p#error').should have(0).errors }
      it{ subject.all('p#notice').should have(0).notices }

      describe "auth_token" do
        it { subject.driver.request.cookies['auth_token'].should eq(user.auth_token) }
      end
    end

    context "with invalid credentials" do
      let(:user) {build :user}

      its("current_path") {should eq(login_path) }
      it{ should have_content("Invalid user/password combination") }
    end
  end

  describe "#destroy" do
    subject { logout }

    its("current_path"){ should eq(login_path) }
    it{ should have_content("Logged Out") }
    it{ subject.all('p#error').should have(0).errors }
    it{ subject.all('p#notice').should have(0).notices }

    context "Attempting to visit page" do
      subject do
        visit cars_path
        page
      end

      its("current_path") { should eq(login_path) }
    end
  end
end
