require 'spec_helper'

describe "lecture 6" do
  
  before do
    @user = User.create! name: "Matt", email: "goggin13@gmail.com", password: "foobar"
  end
    
  def user_login(user)
    visit new_session_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: @user.password
    click_button "Login" 
  end

  def should_be_on_home_page
    page.should have_selector('h1', text: 'INFO 2310 MicroPoster')
  end

  def should_have_error(msg)
    page.should have_selector('div.alert-error', text: msg)
  end

  def should_have_notice(msg)
    page.should have_selector('div.alert-notice', text: msg)
  end

  def should_be_on_home_page_with_error(msg)
    should_be_on_home_page
    should_have_error msg
  end

  describe "login form" do

    describe "unauthenticated" do

      before do
        visit new_session_path
      end

      it "should show you the login form" do
        page.should have_selector('h1', text: 'Login')  
      end
    end

    describe "authenticated" do

      before do
        user_login @user
        visit new_session_path
      end

      it "should show you the home page" do
        page.should_not have_selector('h1', text: 'Login')
        should_be_on_home_page 
      end
    end
  end

  describe "registration form" do

    describe "unauthenticated" do

      before do
        visit new_user_path
      end

      it "should show you the registration form" do
        page.should have_selector('h1', text: 'New user')  
      end
    end

    describe "authenticated" do

      before do
        user_login @user
        visit new_user_path
      end

      it "should show you the home page" do
        page.should_not have_selector('h1', text: 'New user')
        should_be_on_home_page 
      end
    end
  end  

  describe "user access control" do
    
    describe "an unauthenticated user" do
      
      it "should not be able to edit a user" do
        visit edit_user_path(@user)
        should_be_on_home_page_with_error "You are not authorized to edit that user"
      end
      
      it "should not be able to destroy a user" do
        visit users_path
        expect {
          click_link "Destroy"
        }.to change(User, :count).by(0)
        should_be_on_home_page_with_error "You are not authorized to edit that user"
      end
    end

    describe "an authenticated user" do

      before { user_login @user }
      
      it "should be able to edit a user" do
        visit edit_user_path(@user)
        page.should have_selector('h1', text: 'Editing user')
        fill_in 'Name', with: 'Matthew'
        click_button 'Update User'
        should_have_notice 'User was successfully updated.'
      end
      
      it "should be able to destroy a user" do
        visit users_path
        expect {
          click_link "Destroy"
        }.to change(User, :count).by(-1)
      end
    end    
  end

  describe "micropost access control" do
    
    before do
      @my_micro_post = @user.micro_posts.create! content: "hello world" 
    end

    describe "an unauthenticated user" do
      
      it "should not be able to edit a micropost" do
        visit edit_micro_post_path(@my_micro_post)
        should_be_on_home_page_with_error "You are not authorized to edit that MicroPost"
      end
      
      it "should not be able to destroy a micropost" do
        visit micro_posts_path
        click_link 'Destroy'
        should_be_on_home_page_with_error "You are not authorized to edit that MicroPost"
      end
    end

    describe "an authenticated user" do

      before do 
        other_user = User.create! email: "example-2@example.com", 
                                 name: "example", 
                                 password: "password"
        @their_micro_post = other_user.micro_posts.create! content: "hello world" 
        user_login @user 
      end
      
      it "should be able to edit their own micropost " do
        visit edit_micro_post_path(@my_micro_post)
        page.should have_selector('h1', text: 'Editing micro_post')
        fill_in 'Content', with: 'Hello world'
        click_button 'Update Micro post'
        should_have_notice 'Micro post was successfully updated.'
      end

      it "should not be able to edit someone else's  micropost " do
        visit edit_micro_post_path(@their_micro_post)
        should_be_on_home_page_with_error "You are not authorized to edit that MicroPost"
      end      
      
      it "should be able to destroy their own micro_posts " do
        visit micro_posts_path 
        expect {
          find("a[href='#{micro_post_path(@my_micro_post)}'][data-method='delete']").click
        }.to change(MicroPost, :count).by(-1)
      end

      it "should not be able to destroy someone else's micro_posts " do
        visit micro_posts_path 
        expect {
          find("a[href='#{micro_post_path(@their_micro_post)}'][data-method='delete']").click
        }.to change(MicroPost, :count).by(0)
        should_be_on_home_page_with_error "You are not authorized to edit that MicroPost"
      end
    end    
  end  

  describe "users link" do
    
    before { visit root_path }

    it "should appear in the header" do
      page.should have_link('Users', href: users_path)
    end
  end

  describe "paginating users" do
    
    before do
      @users = (0..60).map do |i|
        User.create name: "user-#{i}",
                    email: "user-#{i}@example.com",
                    password: "foobar"
      end
      @users << @user
    end

    it "should display 30 users at a time" do
      visit users_path
      @users[0..28].each do |user|
        page.should have_content user.name
      end
    page.should_not have_content @users[29].name
    end
    
    it "should display the second 30 users on page 2" do
      visit users_path(page: 2)
      @users[29..48].each do |user|
        page.should have_content user.name
      end
	  page.should_not have_content @users[0].name
    end

    it "should have a link to the next page" do
      visit users_path
	  page.should have_css("a[href='#{users_path(page:2)}']")
    end
  end

  describe "paginating micro_posts" do
    
    before do
      @micro_posts = (0..20).map do |i|
        @user.micro_posts.create! content: "hello world, #{i}"
      end
    end

    it "should display 30 micro_posts at a time" do
      visit user_path(@user)
      @micro_posts[0..9].each do |post|
        page.should have_content post.content
      end
	  page.should_not have_content @micro_posts[10].content
    end
    
    it "should display the second 30 users on page 2" do
      visit user_path(@user, page: 2)
      @micro_posts[10..19].each do |post|
        page.should have_content post.content
      end
	  page.should_not have_content @micro_posts[0].content
    end

    it "should have a link to the next page" do
      visit user_path(@user)
	  page.should have_css("a[href='#{user_path(@user, page:2)}']")
    end
  end

  describe "paperclip" do

    it "should include avatar in attr_accessible" do
      lambda do
        @user.update_attributes! avatar: nil
      end.should_not raise_exception
    end

    it "should have the attached file on the user model" do
      @user.should respond_to :avatar
    end

    it "should have a file field on the user edit form" do
      user_login @user
      visit edit_user_path(@user)
      page.should have_css('input[name="user[avatar]"][type="file"]')
    end 

    it "should display a medium sized image on the user profile" do
      visit user_path(@user)
      page.should have_selector('img', src: @user.avatar.url(:medium))
    end

    it "should display an thumb sized image on the user index page" do
      visit user_path(@user)
      page.should have_selector('img', src: @user.avatar.url(:thumb))
    end
  end
end