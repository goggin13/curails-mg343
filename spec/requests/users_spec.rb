require 'spec_helper'

describe "Users" do

  describe "GET /users" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get users_path
      response.status.should be(200)
    end
  end

  describe "GET /users/id" do
    
    before do
      @user = User.create! name: "Matt", 
                           email: "goggin13@gmail.com",
                           password: "foobar"
      3.times { |i| @user.micro_posts.create! content: "hello world - #{i}" }
    end

    it "should display the number of posts the user has" do
      visit user_path(@user)
      page.should have_content("3 MicroPosts")
    end

    it "should list the " do
      visit user_path(@user)
      3.times do |i|
        page.should have_content "hello world - #{i}"
      end
    end
  end
end
