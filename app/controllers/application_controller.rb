class ApplicationController < ActionController::Base
  # ログイン認証が済んでいない状態でトップページ以外の画面にアクセスしても、ログイン画面へリダイレクトする。
  # before_actionメソッドは、このコントローラが動作する前に実行される。 app/controllers/application_controller.rbファイルに記述したので、すべてのコントローラで、最初にbefore_actionメソッドが実行される。
  # authenticate_userメソッドは、devise側が用意しているメソッド。
  before_action :authenticate_user!, except: [:top]
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
