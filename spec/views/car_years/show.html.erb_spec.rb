require 'spec_helper'

describe "car_years/show" do
  before(:each) do
    @car_year = assign(:car_year, stub_model(CarYear,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
