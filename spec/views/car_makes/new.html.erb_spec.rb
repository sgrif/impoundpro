require 'spec_helper'

describe "car_makes/new" do
  before(:each) do
    assign(:car_make, stub_model(CarMake,
      :name => "MyString",
      :kbb_id => 1
    ).as_new_record)
  end

  it "renders new car_make form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => car_makes_path, :method => "post" do
      assert_select "input#car_make_name", :name => "car_make[name]"
      assert_select "input#car_make_kbb_id", :name => "car_make[kbb_id]"
    end
  end
end
