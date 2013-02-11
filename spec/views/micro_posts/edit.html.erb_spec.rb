require 'spec_helper'

describe "micro_posts/edit" do
  before(:each) do
    @micro_post = assign(:micro_post, stub_model(MicroPost,
      :user_id => 1,
      :content => "MyString"
    ))
  end

  it "renders the edit micro_post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => micro_posts_path(@micro_post), :method => "post" do
      assert_select "input#micro_post_user_id", :name => "micro_post[user_id]"
      assert_select "input#micro_post_content", :name => "micro_post[content]"
    end
  end
end
