class SessionsController < ApplicationController
  before_filter :redirect_home_if_signed_in, only: [:new, :create]
  
  def new
  end

  def create
	user = User.authenticate(params[:session][:email], params[:session][:password])
	if user
	  sign_in(user)
	  flash[:notice] = "Welcome, #{user.email}!"
	  redirect_to user_path(user)
	else
	  flash[:error] = "Invalid email/password combination"
	  redirect_to new_session_path
	end
  end

  def destroy
    flash[:notice] = "Logged out #{current_user.email}"
	sign_out_user
	redirect_to root_path
  end

end