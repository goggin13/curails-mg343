require "spec_helper"

describe UserMailer do
  describe "welcome" do

    before do
      @user = User.create! name: 'matt', email: 'matt@example.com', password: 'password'
      @mail = UserMailer.welcome(@user)
    end

    it "renders the headers" do
      @mail.subject.should eq("Welcome to the Info2310 MicroPoster")
      @mail.to.should eq([@user.email])
      @mail.from.should eq(["web@info2310.com"])
    end

    it "renders the body" do
      @mail.body.encoded.should match(@user.name)
    end
  end

  describe "mentioned" do
    before do
      @friend = User.create! name: 'matt', email: 'matt@example.com', password: 'password'
      @user = User.create! name: 'alice', email: 'alice@example.com', password: 'password'
      @micro_post = @user.micro_posts.create! content: "studying with @#{@friend.name}"
      @mail = UserMailer.mentioned(@micro_post, @friend)
    end

    it "renders the headers" do
      @mail.subject.should eq("You were mentioned")
      @mail.to.should eq([@friend.email])
      @mail.from.should eq(["web@info2310.com"])
    end

    it "renders the body" do
      @mail.body.encoded.should match(@friend.name)
      @mail.body.encoded.should match(@micro_post.user.name)
      @mail.body.encoded.should match(micro_post_url(@micro_post))
    end
  end
end