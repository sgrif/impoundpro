require "spec_helper"

describe CarYearsController do
  describe "routing" do

    it "routes to #index" do
      get("/car_years").should route_to("car_years#index")
    end

    it "routes to #new" do
      get("/car_years/new").should route_to("car_years#new")
    end

    it "routes to #show" do
      get("/car_years/1").should route_to("car_years#show", :id => "1")
    end

    it "routes to #edit" do
      get("/car_years/1/edit").should route_to("car_years#edit", :id => "1")
    end

    it "routes to #create" do
      post("/car_years").should route_to("car_years#create")
    end

    it "routes to #update" do
      put("/car_years/1").should route_to("car_years#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/car_years/1").should route_to("car_years#destroy", :id => "1")
    end

  end
end
