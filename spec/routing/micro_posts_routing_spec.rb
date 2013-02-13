require "spec_helper"

describe MicroPostsController do
  describe "routing" do

    it "routes to #index" do
      get("/micro_posts").should route_to("micro_posts#index")
    end

    it "routes to #new" do
      get("/micro_posts/new").should route_to("micro_posts#new")
    end

    it "routes to #show" do
      get("/micro_posts/1").should route_to("micro_posts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/micro_posts/1/edit").should route_to("micro_posts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/micro_posts").should route_to("micro_posts#create")
    end

    it "routes to #update" do
      put("/micro_posts/1").should route_to("micro_posts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/micro_posts/1").should route_to("micro_posts#destroy", :id => "1")
    end

  end
end
