require 'spec_helper'

describe "car_trims/show" do
  before(:each) do
    @car_trim = assign(:car_trim, stub_model(CarTrim,
      :car_model_id => 1,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
