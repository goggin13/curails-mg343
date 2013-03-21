require 'spec_helper'

describe Relationship do

  before do
    @follower = User.create! name: 'follower', 
                             email: 'follower@example.com', 
                             password: 'password'
    @followed = User.create! name: 'followed', 
                             email: 'followed@example.com', 
                             password: 'password'
    @attrs = {followed_id: @followed.id, follower_id: @follower.id}
    @relationship = Relationship.new @attrs
  end

  describe "validations" do
    
    describe "with valid attributes" do
      
      it "should be valid" do
        @relationship.should be_valid
      end
    end

    describe "with no follower_id" do
      
      before do
        @relationship.follower_id = nil
      end

      it "should not be valid" do
        @relationship.should_not be_valid
      end
    end

    describe "with no followed_id" do
      
      before do
        @relationship.followed_id = nil
      end

      it "should not be valid" do
        @relationship.should_not be_valid
      end
    end

    describe "with a duplicate followed_id/follower_id" do
      
      before do
        @relationship.save!
        @relationship = Relationship.new(@attrs)
      end

      it "should not be valid" do
        @relationship.should_not be_valid
      end
    end
  end

  describe "relationships" do

    it "should have a follower" do
      @relationship.follower.should == @follower
    end

    it "should have a followed" do
      @relationship.followed.should == @followed
    end
  end
end