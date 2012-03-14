require 'spec_helper'

describe "Cars" do
  let(:user) {create(:user)}
  
  let(:index) do
    3.times{create(:car)}
    visit login_path
    fill_in 'email', :with => user.email
    fill_in 'password', :with => user.password
    click_button 'Login'
    page
  end

  describe "#index" do    
    subject{ index }
        
    it { should have_content("Active Lien Procedure Vehicles") }
    it { subject.all('table#cars tr').should have(user.cars.count).cars } 
  end
  
  describe "#create" do
    let(:create_request) do
      index
      click_link "New Car"
      attributes_for(:car).each do |key, value|
        fill_field("car_#{key}", value)
      end
      save_and_open_page
      page
    end
    
    subject { create_request }
    
    it { should have_content("New car") }
  end
end
