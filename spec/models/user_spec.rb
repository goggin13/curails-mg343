require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Example User", 
                     email: "user@example.com")
  end

  describe "with valid attributes" do
    
    it "should be valid" do
      @user.should be_valid
    end
  end
  
  describe "without a name" do
    
    before do
      @user.name = ""
    end
    
    it "should not be valid" do
      @user.should_not be_valid
    end
  end
  
  describe "without an email" do
    
    before do
      @user.email = ""
    end
  
    it "should not be valid" do
      @user.should_not be_valid
    end    
  end
end