require 'spec_helper'

describe Car do
  let(:user) { FactoryGirl.create(:user) }
  let(:car) { FactoryGirl.create(:car, user: user) }

  subject { car }

  describe '#status and #order_by_status' do
    let(:user) do
      u = FactoryGirl.create(:user)

      c = FactoryGirl.create(:car, user: u)
      FactoryGirl.create(:lien_procedure, car: c)
      FactoryGirl.create(:car, user: u)
      [:mvd_inquiry_soon, :mvd_inquiry_required, :lien_notice_soon, :lien_notice_required, :public_sale_soon, :public_sale_required].each do |t|
        c = FactoryGirl.create(:car, user: u)
        FactoryGirl.create(:lien_procedure, t, car: c)
      end
      u
    end

    let(:action_required_index) { 3 }
    let(:action_soon_index) { 3 + action_required_index }
    let(:active_index) { 1 + action_soon_index }

    describe "no lien_procedure" do
      its(:status){ should == "inactive" }
      its(:active_lien_procedure){ should be_nil }
      its(:id){ should == user.cars.order_by_status.reload.last.id }
    end

    describe "towed today" do
      before { FactoryGirl.create(:lien_procedure, car: car) }

      its(:status){ should == "active" }
      its('active_lien_procedure.next_step'){ should eq(:mvd_inquiry_date) }
      its(:id){ should == user.cars.order_by_status[active_index].id }
    end

    describe "towed yesterday" do
      before { FactoryGirl.create(:lien_procedure, :mvd_inquiry_soon, car: car) }

      its(:status){ should == "action soon" }
      its("active_lien_procedure.next_step"){ should eq(:mvd_inquiry_date) }
      its(:id){ should == user.cars.order_by_status[action_soon_index].id }
    end

    describe "towed 2 days ago" do
      before { FactoryGirl.create(:lien_procedure, :mvd_inquiry_required, car: car) }

      its(:status){ should == "action required" }
      its("active_lien_procedure.next_step"){ should eq(:mvd_inquiry_date) }
      its(:id){ should == user.cars.order_by_status[action_required_index].id }
    end

    describe "mvd_inquiry today" do
      before { FactoryGirl.create(:lien_procedure, :mvd_inquiry_finished, car: car) }

      its(:status){ should == "active" }
      its("active_lien_procedure.next_step"){ should eq(:lien_notice_mail_date) }
      its(:id){ should == user.cars.order_by_status[active_index].id }
    end

    describe "mvd_inquiry 3 days ago" do
      before { FactoryGirl.create(:lien_procedure, :lien_notice_soon, car: car) }

      its(:status){ should == "action soon" }
      its("active_lien_procedure.next_step"){ should eq(:lien_notice_mail_date) }
      its(:id){ should == user.cars.order_by_status[action_soon_index].id }
    end

    describe "mvd_inquiry 5 days ago" do
      before { FactoryGirl.create(:lien_procedure, :lien_notice_required, car: car) }

      its(:status){ should == "action required" }
      its("active_lien_procedure.next_step"){ should eq(:lien_notice_mail_date) }
      its(:id){ should == user.cars.order_by_status[action_required_index].id }
    end

    describe "lien_notice today" do
      before { FactoryGirl.create(:lien_procedure, :lien_notice_finished, car: car) }

      its(:status){ should == "active" }
      its("active_lien_procedure.next_step"){ should eq(:notice_of_public_sale_date) }
      its(:id){ should == user.cars.order_by_status[active_index].id }
    end

    describe "lien_notice 8 days ago" do
      before { FactoryGirl.create(:lien_procedure, :public_sale_soon, car: car) }

      its(:status){ should == "action soon" }
      its("active_lien_procedure.next_step"){ should eq(:notice_of_public_sale_date) }
      its(:id){ should == user.cars.order_by_status[action_soon_index].id }
    end

    describe "lien_notice 10 days ago" do
      before { FactoryGirl.create(:lien_procedure, :public_sale_required, car: car) }

      its(:status){ should == "action required" }
      its("active_lien_procedure.next_step"){ should eq(:notice_of_public_sale_date) }
      its(:id){ should == user.cars.order_by_status[action_required_index].id }
    end

    describe "public_sale today" do
      before { FactoryGirl.create(:lien_procedure, :public_sale_finished, car: car) }

      its(:status){ should == "active" }
      its("active_lien_procedure.next_step"){ should be_nil }
      its(:id){ should == user.cars.order_by_status[active_index].id }
    end

  end
end
