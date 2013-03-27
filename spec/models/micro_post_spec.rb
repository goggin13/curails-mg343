require 'spec_helper'

describe MicroPost do

  before do
    @user = User.create! name: "poster", email: "poster@example.com", password: "password"
    @micro_post = @user.micro_posts.build(content: "hello world")
  end

  describe "with valid attributes" do
    
    it "should be valid" do
      @micro_post.should be_valid
    end
  end
  
  describe "without a user_id" do
    
    before do
      @micro_post.user_id = nil
    end
    
    it "should not be valid" do
      @micro_post.should_not be_valid
    end
  end
  
  describe "without any content" do
    
    before do
      @micro_post.content = ""
    end
  
    it "should not be valid" do
      @micro_post.should_not be_valid
    end    
  end
  
  describe "with too short content" do
    
    before do
      @micro_post.content = "hi"
    end
  
    it "should not be valid" do
      @micro_post.should_not be_valid
    end    
  end
  
  describe "with too long content" do
    
    before do
      @micro_post.content = "a" * 141
    end
  
    it "should not be valid" do
      @micro_post.should_not be_valid
    end    
  end

  describe "mentioned users" do

    it "should return an empty array" do
      @micro_post.mentions.should == []
    end    
    
    it "should include users who are mentioned in content" do
      u1 = User.create! name: 'Matt Goggin', email: 'matt@example.com', password: 'foobar'
      u2 = User.create! name: 'Sam Lester', email: 'sam@example.com', password: 'foobar'
      @micro_post.content = "Here is a post about @Matt Goggin@ and @Sam Lester@"
      @micro_post.mentions.should == [u1, u2]
    end
    
    it "should not include users who are not mentioned" do
      u1 = User.create! name: 'Matt Goggin', email: 'matt@example.com', password: 'foobar'
      @micro_post.mentions.should == []
    end

    it "should return nil if users who do not exist are mentioned" do
      @micro_post.content = "This post mentions a @non existant@ user"
      @micro_post.mentions.should == []
    end

    it "should not include the poster" do
      @micro_post.content = "This post mentions the poster @#{@micro_post.user.name}@"
      @micro_post.mentions.should == []
    end
  end

  describe "send_mentions_email" do
    
    it "should send two emails if 2 users are mentioned" do
      u1 = User.create! name: 'Matt Goggin', email: 'matt@example.com', password: 'foobar'
      u2 = User.create! name: 'Sam Lester', email: 'sam@example.com', password: 'foobar'
      @micro_post.content = "Here is a post about @Matt Goggin@ and @Sam Lester@"
      expect do
        @micro_post.save!
      end.to change(ActionMailer::Base.deliveries, :count).by 2
    end
    
    it "should send no emails if no users are mentioned" do
      @micro_post.content = "This post mentions a @non existant@ user"
      expect do
        @micro_post.save!
      end.to change(ActionMailer::Base.deliveries, :count).by 0
    end
  end
end



