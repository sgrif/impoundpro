require 'spec_helper'

describe "car_years/new" do
  before(:each) do
    assign(:car_year, stub_model(CarYear,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new car_year form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => car_years_path, :method => "post" do
      assert_select "input#car_year_name", :name => "car_year[name]"
    end
  end
end
