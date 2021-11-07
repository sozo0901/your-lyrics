class StocksController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    stock = current_user.stocks.new(post_id: post.id)
    stock.save
    redirect_to request.referer
  end

  def destroy
    post = Post.find(params[:post_id])
    stock = current_user.stocks.find_by(post_id: post.id)
    stock.destroy
    redirect_to request.referer
  end

end
