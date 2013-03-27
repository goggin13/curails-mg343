require 'spec_helper'

describe "lecture 9" do
  
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

  describe "welcome email" do
    
    before do
      visit new_user_path
      fill_in 'Email', with: 'matt@example.com'
      fill_in 'Password', with: 'password'
      fill_in 'Name', with: 'Matt'
      click_button "Create User"
    end

    it "should send a welcome email when a user signs up" do
      mail = ActionMailer::Base.deliveries.last
      mail.should_not be_nil
      mail['to'].to_s.should == 'matt@example.com'
      mail['subject'].to_s.should == 'Welcome to the Info2310 MicroPoster'
    end
  end

  describe "mentions email" do
    
    before do
      @friend = User.create! name: 'friend', email: 'friend@example.com', password: 'password'
    end

    it "should send emails to mentioned users" do
      mp = @friend.micro_posts.create! content: "hello @#{@user.name}@ world"
      mail = ActionMailer::Base.deliveries.last
      mail.should_not be_nil
      mail['to'].to_s.should == @user.email
      mail['subject'].to_s.should == "You were mentioned"
      mail.to_s.index(micro_post_url(mp)).should_not be_nil
    end
  end
end