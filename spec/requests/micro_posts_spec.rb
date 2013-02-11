require 'spec_helper'

describe "MicroPosts" do
  describe "GET /micro_posts" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get micro_posts_path
      response.status.should be(200)
    end
  end
end
