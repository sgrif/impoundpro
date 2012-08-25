require 'spec_helper'

describe Car do
  describe '.status' do
    let(:user) { FactoryGirl.create(:user) }
    let(:car) { FactoryGirl.create(:car) }

    describe "no lien_procedure" do
      subject { car }

      its(:status){ should == "inactive" }
      its(:active_lien_procedure){ should be_nil }
    end

    describe "towed today" do
      before { car.lien_procedures.create(date_towed: Date.today) }
      subject { car }

      its(:status){ should == "active" }
      its('active_lien_procedure.next_step'){ should eq(:mvd_inquiry_date) }
    end
  end
end
