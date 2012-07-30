require 'spec_helper'

describe "car_trims/new" do
  before(:each) do
    assign(:car_trim, stub_model(CarTrim,
      :car_model_id => 1,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new car_trim form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => car_trims_path, :method => "post" do
      assert_select "input#car_trim_car_model_id", :name => "car_trim[car_model_id]"
      assert_select "input#car_trim_name", :name => "car_trim[name]"
    end
  end
end
