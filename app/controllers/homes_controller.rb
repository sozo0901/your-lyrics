class HomesController < ApplicationController
  before_action :redirect_posts

  # ユーザーがログインしている場合、トップページへは遷移できず投稿一覧画面を表示させる
  def redirect_posts
    if user_signed_in?
      redirect_to posts_path
    end
  end

  def top

  end
end
