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

  describe "relationships" do
    
    before do
      @user.save
    end

    it "should have a relationships function" do
      @user.should respond_to :relationships
    end

    it "should have a followed_users function" do
      friends = (0..1).map do |i|
        u = User.create! name: "user-#{i}", email: "#{i}@example.com", password: 'password'
        Relationship.create! follower_id: @user.id, followed_id: u.id
        u
      end
      @user.followed_users.should == friends
    end

    it "should be destroyed when the user is" do
      @user.relationships.create! followed_id: 2
      expect {
        @user.destroy
      }.to change(Relationship, :count).by(-1)
    end
  end

  describe "following functions" do
    
    before do
      @user.save!
      @friend = User.create! name: 'friend', email: 'friend@example.com', password: 'password'
    end

    describe "following?" do
      
      it "should return nil if the user is not following them" do
        @user.following?(@friend).should be_nil
      end

      it "should return not nil if the user is following them" do
        Relationship.create! follower_id: @user.id, followed_id: @friend.id
        @user.following?(@friend).should_not be_nil
        @friend.following?(@user).should be_nil
      end
    end

    describe "follow!" do
      
      it "should create a relationship if one doesn't exist" do
        expect {
          @user.follow! @friend
        }.to change(Relationship, :count).by(1)
        Relationship.where('follower_id = ? and followed_id = ?', 
                            @user.id, @friend.id).first.should_not be_nil
      end
    end

    describe "unfollow!" do

      it "should destroy a relationship if one exists" do
        Relationship.create! follower_id: @user.id, followed_id: @friend.id
        expect {
          @user.unfollow! @friend
        }.to change(Relationship, :count).by(-1)
        Relationship.where('follower_id = ? and followed_id = ?', 
                            @user.id, @friend.id).first.should be_nil
      end
    end
  end

  describe "feed" do
    
    before do
      @user.save
      @friend = User.create! name: 'friend', email: 'friend@example.com', password: 'password'
    end

    it "should return an empty array if there are no microposts" do
      @user.feed.should == []
    end

    it "should return the users micro posts if they have posted" do
      micro_post = @user.micro_posts.create! content: "hello, world"
      @user.feed[0].should == micro_post
    end

    it "should include posts from followed users" do
      @user.follow! @friend
      micro_post = @friend.micro_posts.create! content: "hello, world"
      @user.feed[0].should == micro_post
    end

    it "should not include posts from unfollowed users" do
      micro_post = @friend.micro_posts.create! content: "hello, world"
      @user.feed.should == []
    end

    it "should be sorted by descending creation date" do
      mp2 = @user.micro_posts.create! content: "hello"
      mp1 = @user.micro_posts.create! content: "hello"
      mp2.created_at = Time.now.advance(:hours => -1) 
      mp2.save
      @user.feed.should == [mp1, mp2]
    end

    it "should be paginated" do
      mp1 = @user.micro_posts.create! content: "hello"
      mp2 = @user.micro_posts.create! content: "hello"
      mp2.created_at = Time.now.advance(:hours => -1) 
      mp2.save
      @user.feed(page: 2, per_page:1).should == [mp2]
    end
  end
end