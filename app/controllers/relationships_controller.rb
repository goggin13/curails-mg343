class RelationshipsController < ApplicationController

	# params[:relationship][:followed_id] contains the id of the user to follow;
	# use our functions from the last exercise to have the current_user follow them
	def create
		# your code here, populate the @user variable and make the current_user follow them
		@user = User.find params[:relationship][:followed_id]
		current_user.follow! @user
		
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end

	# params[:relationship][:followed_id] contains the id of the user to follow;
	# use our functions from the last exercise to have the current_user UNfollow them
	def destroy
		# your code here, populate the @user variable make the current_user unfollow them
		@user = User.find params[:relationship][:followed_id]
		current_user.unfollow! @user
		
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end
end