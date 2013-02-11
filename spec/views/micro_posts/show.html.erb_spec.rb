require 'spec_helper'

describe "micro_posts/show" do
  before(:each) do
    @micro_post = assign(:micro_post, stub_model(MicroPost,
      :user_id => 1,
      :content => "Content"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Content/)
  end
end
