require 'spec_helper'

describe "car_years/index" do
  before(:each) do
    assign(:car_years, [
      stub_model(CarYear,
        :name => "Name"
      ),
      stub_model(CarYear,
        :name => "Name"
      )
    ])
  end

  it "renders a list of car_years" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
