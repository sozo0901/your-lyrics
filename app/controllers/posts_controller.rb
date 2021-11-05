class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    # データを新規登録するためのインスタンス作成
    @post = Post.new(post_params)
    # current_userはdeviseのヘルパーメソッド。deviseを導入しないと使用できない。
    @post.user_id = current_user.id
    # データをデータベースに保存するためのsaveメソッド実行
    @post.save
    # 投稿一覧画面へ遷移
    redirect_to posts_path
  end

  def index
    # タイムライン上に表示する投稿データを取得
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :image, :body)
  end

end
