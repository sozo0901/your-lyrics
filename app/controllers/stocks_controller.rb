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

end
