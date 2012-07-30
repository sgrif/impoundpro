require 'spec_helper'

describe "car_makes/index" do
  before(:each) do
    assign(:car_makes, [
      stub_model(CarMake,
        :name => "Name",
        :kbb_id => 1
      ),
      stub_model(CarMake,
        :name => "Name",
        :kbb_id => 1
      )
    ])
  end

  it "renders a list of car_makes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
