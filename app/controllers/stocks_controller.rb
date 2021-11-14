class StocksController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    stock = current_user.stocks.new(post_id: @post.id)
    stock.save
    # app/views/stocks/create.js.erbを参照する
  end

  def destroy
    @post = Post.find(params[:post_id])
    stock = current_user.stocks.find_by(post_id: @post.id)
    stock.destroy
    # app/views/stocks/destroy.js.erbを参照する
  end

  def stocked_posts
    post_ids = current_user.stocks.pluck(:post_id)
    @posts = Post.where(id: post_ids).order(created_at: :desc)
  end

end
