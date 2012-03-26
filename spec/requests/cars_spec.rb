require 'spec_helper'
require 'pdf/inspector'

describe "Cars" do
  before(:each) { car }
  
  let(:car) { create :car, :user => user, :paid => true }
  
  let(:user) { create :user }
  
  let(:car_attributes) { attributes_for(:car) }
  
  let(:index) do
    visit login_path
    fill_in 'email', :with => user.email
    fill_in 'password', :with => user.password
    click_button 'Login'
    page
  end

  describe "#index" do
    before(:each) { 3.times{create(:car)} }  
    subject{ index }
        
    it { should have_content("Active Lien Procedure Vehicles") }
    it { subject.all('table#cars>tr').should have(user.cars.count).cars } 
  end
  
  describe "#new", :js => true do
    let(:new_page) do
      index
      click_link "New Car"
      page
    end
    
    let(:add_values) do
      car_attributes.each do |key, value|
        fill_field("car_#{key}", value, new_page)
      end
    end
    
    subject { new_page }
    
    context "while adding values" do
      it { expect{add_values}.to change{subject.find_field('car_charge_subtotal').value}.from('0.0') }
      it { expect{add_values}.to change{subject.find_field('car_charge_total').value}.from("0.0") }
    end
  end
  
  describe "#create" do
    let(:create_request) do
      index
      click_link "New Car"
      car_attributes.each do |key, value|
        fill_field("car_#{key}", value, page)
      end
      click_button "Create"
      page
    end
    
    subject { create_request }
    
    context "with valid attributes" do
      its("current_path") { should eq(cars_path) }
      it{ should have_content('successfully created') }
      it{ expect{ create_request }.to change{Car.count}.by(1) }
      
      describe "cars table" do
        subject {create_request.all("table#cars tr")}
        its("first") { should have_content(car_attributes[:vin]) }
        its("first") { should_not have_content(Car.first.vin)}
      end
    end
    
    context "with invalid attributes" do
      let(:car_attributes) {[]}
      
      its("current_path") { should eq(cars_path) }
      it{ expect{ create_request }.not_to change{Car.count} }
      it{ subject.all('#error_explanation li').should have_at_least(1).errors }
    end
  end
  
  describe "#edit", :js => true do
    let(:edit_page) do
      index
      click_link "Edit"
      page
    end
    
    let(:change_values) do
      car_attributes.each do |key, value|
        fill_field("car_#{key}", value, edit_page)
      end
    end
    
    subject { edit_page }
    
    context "while adding values" do
      describe "subtotal field" do
        it { expect{change_values}.to change{subject.find_field('car_charge_subtotal').value} }
      end
      
      context "total field after changing charges" do
        describe "total field" do
          it { expect{change_values}.to change{subject.find_field('car_charge_total').value} }
        end
      end
    end
  end
  
  describe "#update" do
    let(:update_request) do
      index
      find(:xpath, "//a[@href='#{edit_car_path(car)}']").click
      car_attributes.each do |key, value|
        fill_field("car_#{key}", value, page)
      end
      click_button "Update"
      page
    end
    
    subject { update_request }
    
    it { expect{ update_request }.not_to change{Car.count} }
    
    context "with valid attributes" do
      its("current_path") { should eq(car_path(car)) }
      it { should have_content('successfully updated') }
      it {expect{ update_request }.to change{Car.find(car.id).make}.to(car_attributes[:make])}
    end
    
    context "with invalid attributes" do
      let(:car_attributes) {{:vin => ''}}
      
      its("current_path") { should eq(car_path(car)) }
      it{ subject.all('#error_explanation li').should have_at_least(1).errors }
    end
  end
  
  describe "#destroy" do
    let(:destroy_request) do
      index
      find(:xpath, "//a[@href='#{car_path(car)}' and @data-method='delete']").click
      page
    end
    
    subject { destroy_request }
    
    it { expect{ destroy_request }.to change{Car.count}.by(-1) }
    its("current_path") { should eq(cars_path) }
    it { should have_content("successfully deleted") }
  end
  
  describe "#owner_lien_notice.pdf" do
    let(:pdf) do
      index
      find(:xpath, "//a[@href='#{owner_lien_notice_car_path(car, :format => :pdf)}']").click
      page
    end
    
    subject { pdf }
    
    its("current_path") { should eq(owner_lien_notice_car_path(car, :format => :pdf)) }
    it { should have_content "%PDF-1.3" }
    
    context "file" do
      subject { PDF::Inspector::Page.analyze(pdf.source) }
      
      it "should have correct number of pages" do
        if car.charges.count <= 4
          subject.pages.count.should eq(1)
        else
          subject.pages.count.should eq(2)
        end
      end
    end
  end
  
  describe "#lien_holder_lien_notice.pdf" do
    let(:pdf) do
      index
      find(:xpath, "//a[@href='#{lien_holder_lien_notice_car_path(car, :format => :pdf)}']").click
      page
    end
    
    subject { pdf }
    
    its("current_path") { should eq(lien_holder_lien_notice_car_path(car, :format => :pdf)) }
    it { should have_content "%PDF-1.3" }
  end
  
  describe "#driver_lien_notice.pdf" do
    let(:pdf) do
      index
      find(:xpath, "//a[@href='#{driver_lien_notice_car_path(car, :format => :pdf)}']").click
      page
    end
    
    subject { pdf }
    
    its("current_path") { should eq(driver_lien_notice_car_path(car, :format => :pdf)) }
    it { should have_content "%PDF-1.3" }
  end
  
  describe "#owner_mail_labels.pdf" do
    let(:pdf) do
      index
      find(:xpath, "//a[@href='#{owner_mail_labels_car_path(car, :format => :pdf)}']").click
      page
    end
    
    subject { pdf }
    
    its("current_path") { should eq(owner_mail_labels_car_path(car, :format => :pdf)) }
    it { should have_content "%PDF-1.3" }
  end
  
  describe "#lien_holder_mail_labels.pdf" do
    let(:pdf) do
      index
      find(:xpath, "//a[@href='#{lien_holder_mail_labels_car_path(car, :format => :pdf)}']").click
      page
    end
    
    subject { pdf }
    
    its("current_path") { should eq(lien_holder_mail_labels_car_path(car, :format => :pdf)) }
    it { should have_content "%PDF-1.3" }
  end
  
  describe "#driver_mail_labels.pdf" do
    let(:pdf) do
      index
      find(:xpath, "//a[@href='#{driver_mail_labels_car_path(car, :format => :pdf)}']").click
      page
    end
    
    subject { pdf }
    
    its("current_path") { should eq(driver_mail_labels_car_path(car, :format => :pdf)) }
    it { should have_content "%PDF-1.3" }
  end
  
  describe "#notice_of_public_sale.pdf" do
    let(:pdf) do
      index
      find(:xpath, "//a[@href='#{notice_of_public_sale_car_path(car, :format => :pdf)}']").click
      page
    end
    
    subject { pdf }
    
    its("current_path") { should eq(notice_of_public_sale_car_path(car, :format => :pdf)) }
    it { should have_content "%PDF-1.3" }
  end
  
  describe "#affidavit_of_resale.pdf" do
    let(:pdf) do
      index
      find(:xpath, "//a[@href='#{affidavit_of_resale_car_path(car, :format => :pdf)}']").click
      page
    end
    
    subject { pdf }
    
    its("current_path") { should eq(affidavit_of_resale_car_path(car, :format => :pdf)) }
    it { should have_content "%PDF-1.3" }
  end
  
  describe "#title_application.pdf" do
    let(:pdf) do
      index
      find(:xpath, "//a[@href='#{title_application_car_path(car, :format => :pdf)}']").click
      page
    end
    
    subject { pdf }
    
    its("current_path") { should eq(title_application_car_path(car, :format => :pdf)) }
    it { should have_content "%PDF-1.3" }
  end
  
  describe "#fifty_state_check.pdf" do
    let(:pdf) do
      index
      find(:xpath, "//a[@href='#{fifty_state_check_car_path(car, :format => :pdf)}']").click
      page
    end
    
    subject { pdf }
    
    its("current_path") { should eq(fifty_state_check_car_path(car, :format => :pdf)) }
    it { should have_content "%PDF-1.3" }
  end
  
  describe "#unclaimed_vehicles_report.pdf" do
    let(:pdf) do
      create_list :car, 25, :user => user
      index
      find(:xpath, "//a[@href='#{cars_unclaimed_vehicles_report_path(:format => :pdf)}']").click
      page
    end
    
    subject { pdf }
    
    its("current_path") { should eq(cars_unclaimed_vehicles_report_path(:format => :pdf)) }
    it { should have_content "%PDF-1.3" }
    
    describe "file" do
      subject { PDF::Inspector::Page.analyze(pdf.source) }
            
      its("pages.count") { pdf; should eq((user.cars.where("date_towed >= '#{30.days.ago}'").count/10.0).ceil) }
    end
  end
end
