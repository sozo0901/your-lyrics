class LikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    like = current_user.likes.new(post_id: @post.id)
    like.save
    # app/views/likes/create.js.erbを参照する
  end

  def destroy
    @post = Post.find(params[:post_id])
    like = current_user.likes.find_by(post_id: @post.id)
    like.destroy
    # app/views/likes/destroy.js.erbを参照する
  end

  def liked_posts
    post_ids = current_user.likes.pluck(:post_id)
    @posts = Post.where(id: post_ids).page(params[:page]).order(created_at: :desc)
  end
end
