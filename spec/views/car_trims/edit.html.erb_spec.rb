require 'spec_helper'

describe "car_trims/edit" do
  before(:each) do
    @car_trim = assign(:car_trim, stub_model(CarTrim,
      :car_model_id => 1,
      :name => "MyString"
    ))
  end

  it "renders the edit car_trim form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => car_trims_path(@car_trim), :method => "post" do
      assert_select "input#car_trim_car_model_id", :name => "car_trim[car_model_id]"
      assert_select "input#car_trim_name", :name => "car_trim[name]"
    end
  end
end
