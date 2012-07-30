require 'spec_helper'

describe "car_makes/edit" do
  before(:each) do
    @car_make = assign(:car_make, stub_model(CarMake,
      :name => "MyString",
      :kbb_id => 1
    ))
  end

  it "renders the edit car_make form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => car_makes_path(@car_make), :method => "post" do
      assert_select "input#car_make_name", :name => "car_make[name]"
      assert_select "input#car_make_kbb_id", :name => "car_make[kbb_id]"
    end
  end
end
