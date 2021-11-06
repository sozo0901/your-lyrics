class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    # そのユーザ（@user）に関連付けられた投稿（.post_images）のみ@postに渡すことができる記述。
    # 全体の投稿ではなく個人が投稿したもののみを表示。
    @posts = @user.posts.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :image, :caption)
  end
end
