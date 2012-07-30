require 'spec_helper'

describe "car_models/index" do
  before(:each) do
    assign(:car_models, [
      stub_model(CarModel,
        :car_make_id => 1,
        :name => "Name",
        :kbb_id => 1
      ),
      stub_model(CarModel,
        :car_make_id => 1,
        :name => "Name",
        :kbb_id => 1
      )
    ])
  end

  it "renders a list of car_models" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
