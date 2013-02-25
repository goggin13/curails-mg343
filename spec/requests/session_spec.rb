require 'spec_helper'

describe "Session Requests" do
  
  before do
    @user = User.create! name: "Matt", email: "goggin13@gmail.com", password: "foobar"
  end

  describe "login form" do
    
    describe "link" do
  
      it "should be displayed in the header" do
        visit root_path
        page.should have_link("Login", href: new_session_path)
      end
    end
    
    describe "elements" do
      
      before do
        visit new_session_path
      end

      it "should have a field for session[:email]" do
        page.should have_field 'session[email]'
      end
      
      it "should have a field for session[:password]" do
        page.should have_field 'session[password]'
      end

      it "should have a login button" do
        page.should have_button "Login"
      end

      it "should post to sessions_path" do
        page.should have_css "form[action='#{sessions_path}'][method='post']"
      end
    end
  end

  describe "login form submission" do
    
    before do
      visit new_session_path
    end

    describe "on success" do
      
      before do
        fill_in "Email", with: @user.email
        fill_in "Password", with: @user.password
        click_button "Login"
      end
      
      it "should redirect to the users profile page" do
         current_path.should == user_path(@user)
      end

      it "should display a welcome message" do
        page.should have_content "Welcome, #{@user.email}!"
      end
    end

    describe "on failure" do

      before do
        fill_in "Email", with: @user.email
        fill_in "Password", with: "WRONG_PASSWORD"
        click_button "Login"
      end

      it "should display the login form again" do
        current_path.should == new_session_path
      end

      it "should display an error message" do
        page.should have_content "Invalid email/password combination"
      end
    end
  end

  describe "customized header" do
    
    describe "authenticated" do
      
      before do
        visit new_session_path
        fill_in "Email", with: @user.email
        fill_in "Password", with: @user.password
        click_button "Login"
        visit root_path
      end

      it "should not display a login link" do
        page.should_not have_link "Login"
      end

      it "should display a logout link" do
        page.should have_link "Logout"
      end

      it "should have a link to the current user's profile" do
        page.should have_link("My Profile", href: user_path(@user))
      end

      it "should have a link to the current user's account page" do
        page.should have_link("My Account", href: edit_user_path(@user))
      end

      it "should not have a sign up link on the home page" do
        page.should_not have_link "Sign Up"
      end
    end

    describe "anonymous" do
      
      before do
        visit root_path
      end

      it "should display a login link" do
        page.should have_link "Login"
      end

      it "should not display a logout link" do
        page.should_not have_link "Logout"
      end

      it "should not have a My Profile link" do
        page.should_not have_link("My Profile")
      end

      it "should not have a My Account link" do
        page.should_not have_link("My Account")
      end

      it "should have a sign up link on the home page" do
        page.should have_link("Sign Up")
      end
    end
  end

  describe "logging out" do

    before do
      visit new_session_path
      fill_in "Email", with: @user.email
      fill_in "Password", with: @user.password
      click_button "Login"
      click_link "Logout"
    end
    
    it "should redirect to the home page" do
      current_path.should == root_path
    end

    it "should display a farewell message" do
      page.should have_content "Logged out #{@user.email}"
    end

    it "should redisplay the login link" do
      page.should have_link("Login", href: new_session_path)
    end
  end
end