require "spec_helper"

describe CarMakesController do
  describe "routing" do

    it "routes to #index" do
      get("/car_makes").should route_to("car_makes#index")
    end

    it "routes to #new" do
      get("/car_makes/new").should route_to("car_makes#new")
    end

    it "routes to #show" do
      get("/car_makes/1").should route_to("car_makes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/car_makes/1/edit").should route_to("car_makes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/car_makes").should route_to("car_makes#create")
    end

    it "routes to #update" do
      put("/car_makes/1").should route_to("car_makes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/car_makes/1").should route_to("car_makes#destroy", :id => "1")
    end

  end
end
