class RelationsController < ApplicationController
  def create
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end

  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

  def following
    @user = User.find(params[:user_id])
    @users = @user.following.page(params[:page])
  end

  def followers
    @user = User.find(params[:user_id])
    @users = @user.followers.page(params[:page])
  end
end
