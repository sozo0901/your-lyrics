class ApplicationController < ActionController::Base
  # devise利用の機能（ユーザ登録、ログイン認証など）が使われる場合、その前にconfigure_permitted_parametersが実行される
  before_action :configure_permitted_parameters, if: :devise_controller?
  # ログイン後は投稿一覧画面に遷移
  def after_sign_in_path_for(resource)
    posts_path
  end

  # protectedは呼び出された他のコントローラからも参照できる
  protected

  def configure_permitted_parameters
    # nameのデータ操作を許可するアクションメソッド（sign_up時、nameのデータ操作を許可）
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

end
