require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Example User", 
                     email: "user@example.com",
                     password: "foobar")
  end

  describe "with valid attributes" do

    it "should be valid" do
      @user.should be_valid
    end

    it "should be valid if it has an encrypted_password but no password" do
      @user.save
      @user.password = nil
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
        
  describe "without a password" do
    
    before do
      @user.password = ""
    end
    
    it "should not be valid" do
      @user.should_not be_valid
    end
  end
  
  describe "hashed_password" do
    
    it "should be populated after the user has been saved" do
      @user.save
      @user.hashed_password.should_not be_blank
    end
  end
  
  describe "salt" do
    
    it "should be populated after the user has been saved" do
      @user.save
      @user.salt.should_not be_blank
    end
  end
  
  describe "authenticate" do

    before do
      @user.save
    end

    it "should return the user with correct credentials" do
      User.authenticate(@user.email, @user.password).should == @user
    end

    it "should return nil if the given email does not exist" do
      User.authenticate("noone@example.com", @user.password).should be_nil
    end

    it "should return nil if the wrong password is provided" do
      User.authenticate(@user.email, "wrong_password").should be_nil
    end
  end  
end