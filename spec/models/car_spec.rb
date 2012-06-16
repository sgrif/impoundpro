require 'spec_helper'

describe Car do
  let(:car) { create(:car) }
  let(:user) { create(:user) }

  subject { car }

  context "validations" do
    it{ should validate_numericality_of(:year) }
    it{ should ensure_inclusion_of(:year).in_range(1900..Date.current.year + 2) }
    it{ should_not allow_value("notastate").for(:state).with_message('notastate is not a valid state') }
    it{ should validate_uniqueness_of(:vin).scoped_to(:user_id).with_message('There is already an active car on your account with this vin') }
    it{ should validate_uniqueness_of(:license_plate_number).scoped_to(:user_id).with_message('There is already an active car on your account with this LP#') }
    [:year, :make, :model, :size, :color, :state, :vin, :license_plate_number].each {|attr| it{ should validate_presence_of(attr) }}

    it{ should_not allow_value("notastate").for(:owner_state).with_message('notastate is not a valid state') }

    it{ should_not allow_value("notastate").for(:lien_holder_state).with_message('notastate is not a valid state') }

    it{ should_not allow_value("notastate").for(:driver_state).with_message('notastate is not a valid state') }

    [:date_towed, :tow_requested_by, :tow_reason].each {|attr| it{ should validate_presence_of(attr) }}

    [:charge_hook_up, :charge_mileage, :charge_admin, :charge_other, :tax].each {|attr| it{ should validate_numericality_of(attr) }}

    context "#ensure_tax_is_decimal" do
      let(:new_car) { build(:car) }

      context "with tax >= 1" do
        subject do
          new_car.tax = 7
          new_car.save
          new_car
        end

        its(:tax) { should eq(0.07) }
      end

      context "with tax <= 1" do
        subject do
          new_car.tax = 0.07
          new_car.save
          new_car
        end

        its(:tax) { should eq(0.07) }
      end

      context "with tax = 0" do
        subject do
          new_car.tax = 0
          new_car.save
          new_car
        end

        its(:tax) { should eq(0) }
      end
    end

    it { should belong_to(:user) }

    context "#init" do
      let(:new_car) { user.cars.build }

      subject { new_car }

      its(:charge_hook_up) { should eq(0.0) }
      its(:charge_mileage) { should eq(0.0) }
      its(:charge_admin) { should eq(0.0) }
      its(:charge_hook_up) { should eq(0.0) }
      its(:tax) { should eq(0.0) }
      its(:preparers_name) { should eq(new_car.user.preparers_name) }
    end
  end

  context "#charge_storage" do
    context "date towed is today" do
      subject do
        car.date_towed = Date.today
        car.save
        car
      end

      its(:charge_storage) { should eq(car.storage_rate) }
    end

    context "date towed is not today" do
      subject do
        car.date_towed = 2.days.ago
        car.save
        car
      end

      its(:charge_storage) { should eq(car.storage_rate * 3) }
    end
  end
end
