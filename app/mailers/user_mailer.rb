
class UserMailer < ActionMailer::Base
  
  def welcome(user)
    @user = user
    mail(to: user.email, subject: "Welcome to the Info2310 MicroPoster")
  end
  
  def mentioned(micro_post, mentioned_user)
    @mentioned_user = mentioned_user
    @micro_post = micro_post
    mail(to: mentioned_user.email, subject: "You were mentioned")
  end
end

