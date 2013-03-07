require 'spec_helper'

describe "lecture 7" do
  
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

  def should_be_on_home_page_with_notice(msg)
    should_be_on_home_page
    should_have_notice msg
  end 
  
  describe "user feed" do
    
    describe "anonymous" do
      it "should not appear on the home page" do
        visit root_path
        page.should_not have_css('#user_feed')
      end
    end

    describe "authenticated" do

      before do
        50.times { |i| @user.micro_posts.create! content: "hello, world #{i}!" }
        user_login @user
      end
      
      it "should display the first 30 posts by default" do
        visit root_path
        (0..29).each do |i|
          page.should have_content "hello, world #{i}!"
        end
        (30..49).each do |i|
          page.should_not have_content "hello, world #{i}!"
        end
      end

      it "should display the second page if requested" do
        visit root_path(page: 2)
        (0..29).each do |i|
          page.should_not have_content "hello, world #{i}!"
        end
        (30..49).each do |i|
          page.should have_content "hello, world #{i}!"
        end
      end
      
      
      it "should have a link to the next page" do
        visit root_path
        page.should have_css("a[href='#{static_pages_home_path(page:2)}']")
      end
    end
  end

  describe "posting from the home page" do
    
    describe "anonymous" do
      it "should not display the MicroPost form to anonymous users" do
        visit root_path
        page.should_not have_css "[name='micro_post[content]']"
      end
    end
    
    describe "authenticated" do
      
      before do
        user_login @user
        visit root_path
      end

      it "should show the MicroPost form" do
        page.should have_content 'Content'
        page.should have_css "[name='micro_post[content]']"
      end

      it "should set the remote and data-type attributes on the form" do
        page.should have_css 'form[data-remote="true"]'
      end
    end
  end

  describe "deleting micro_posts" do
    
    before do
      @micro_post = @user.micro_posts.create! content: 'hello world'
    end

    describe "anonymous" do

      it "should not display the destroy link" do
        visit root_path
        page.should_not have_link "Destroy"
      end
    end

    describe "authenticated" do
      
      before do
        user_login @user
      end

      it "should display the destroy link for only your micro_posts" do
        visit root_path
        page.should have_css "a[data-remote='true'][data-method='delete']"
      end

      it "should not display destroy links for other users micro_posts" do
        user = User.create!(name: "Example User", 
                            email: "user@example.com",
                            password: "foobar")
        user.micro_posts.create! content: "hello"
        visit user_path(user)
        page.should_not have_css "a[data-remote='true'][data-method='delete']"
      end
    end
  end
end