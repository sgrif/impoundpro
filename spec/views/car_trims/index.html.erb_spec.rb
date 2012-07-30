require 'spec_helper'

describe "car_trims/index" do
  before(:each) do
    assign(:car_trims, [
      stub_model(CarTrim,
        :car_model_id => 1,
        :name => "Name"
      ),
      stub_model(CarTrim,
        :car_model_id => 1,
        :name => "Name"
      )
    ])
  end

  it "renders a list of car_trims" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
