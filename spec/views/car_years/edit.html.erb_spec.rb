require 'spec_helper'

describe "car_years/edit" do
  before(:each) do
    @car_year = assign(:car_year, stub_model(CarYear,
      :name => "MyString"
    ))
  end

  it "renders the edit car_year form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => car_years_path(@car_year), :method => "post" do
      assert_select "input#car_year_name", :name => "car_year[name]"
    end
  end
end
