require 'spec_helper'

describe "car_makes/show" do
  before(:each) do
    @car_make = assign(:car_make, stub_model(CarMake,
      :name => "Name",
      :kbb_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
