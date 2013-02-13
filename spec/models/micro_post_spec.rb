require 'spec_helper'

describe MicroPost do

  before do
    @micro_post = MicroPost.new(user_id: 1, 
                                content: "hello world")
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
end




