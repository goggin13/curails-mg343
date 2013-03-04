class StaticPagesController < ApplicationController

  def home
    if signed_in?
      @feed = current_user.feed page: params[:page]
      @micro_post = MicroPost.new
    end
  end

  def help
  end

  def about
  end
end
