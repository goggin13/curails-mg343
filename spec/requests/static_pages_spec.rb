require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the content 'INFO 2310 MicroPosts'" do
      visit '/static_pages/home'
      page.should have_selector('h1', text: 'INFO 2310 MicroPoster')
    end

    it "should have the title 'Home'" do
      visit '/static_pages/home'
      page.should have_selector('title',
               			:text => "INFO2310 Microposter | Home")
    end
  end

  describe "Help page" do

    it "should have the content 'Help'" do
      visit '/static_pages/help'
      page.should have_selector('h1', text: 'Help')
    end
    it "should have the title 'Help'" do
      visit '/static_pages/help'
      page.should have_selector('title',
                                :text => "INFO2310 Microposter | Help")
    end
  end

  describe "About page" do

    it "should have the content 'About'" do
      visit '/static_pages/about'
      page.should have_selector('h1', text: "About")
    end
    it "should have the title 'About'" do
      visit '/static_pages/about'
      page.should have_selector('title',
                                :text => "INFO2310 Microposter | About")
    end
  end
end
