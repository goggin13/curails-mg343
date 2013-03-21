require 'spec_helper'

describe "lecture 7" do
  
  before do
    @user = User.create! name: "Matt", email: "goggin13@gmail.com", password: "foobar"
    @friend = User.create! name: "Friend", email: "example@gmail.com", password: "foobar"
  end
    
  def user_login(user)
    visit new_session_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: @user.password
    click_button "Login" 
  end

  def has_follow_button?
    page.has_css? 'input[type="submit"][value="Follow"]'
  end

  def has_unfollow_button?
    page.has_css? 'input[type="submit"][value="Unfollow"]'
  end

  describe "follow form" do
    
    describe "anonymous" do
      
      before do 
        visit user_path(@friend)
      end

      it "should not display the follow form" do
        has_follow_button?.should be_false
      end
    end

    describe "authenticated" do
      
      before do
        user_login @user
      end
        
      describe "on another user's page" do

        it "should display the follow form on another user's profile" do
          visit user_path(@friend)
          has_follow_button?.should be_true
        end

        it "should allow them to follow the user" do
          visit user_path(@friend)
          click_button 'Follow'
          @user.following?(@friend).should be_true
        end

        describe "that they are already following" do
          
          before do
            @user.follow! @friend
            visit user_path(@friend)
          end

          it "should display the unfollow form if the user is already following them" do
            has_unfollow_button?.should be_true
          end

          it "should allow them to unfollow the user" do
            visit user_path(@friend)
            click_button 'Unfollow'
            @user.following?(@friend).should be_false
          end
        end
      end
      
      describe "on your profile page" do

        before do
          visit user_path(@user)
        end

        it "should not display the follow form on your own profile" do
          has_follow_button?.should be_false
        end
      end
    end
  end
end