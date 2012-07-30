require "spec_helper"

describe CarTrimsController do
  describe "routing" do

    it "routes to #index" do
      get("/car_trims").should route_to("car_trims#index")
    end

    it "routes to #new" do
      get("/car_trims/new").should route_to("car_trims#new")
    end

    it "routes to #show" do
      get("/car_trims/1").should route_to("car_trims#show", :id => "1")
    end

    it "routes to #edit" do
      get("/car_trims/1/edit").should route_to("car_trims#edit", :id => "1")
    end

    it "routes to #create" do
      post("/car_trims").should route_to("car_trims#create")
    end

    it "routes to #update" do
      put("/car_trims/1").should route_to("car_trims#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/car_trims/1").should route_to("car_trims#destroy", :id => "1")
    end

  end
end
