class SessionsController < ApplicationController
  def new
  end

  def create
  	# 有効なメールアドレスが入力されたときにマッチする
  	user = User.find_by(email: params[:session][:email].downcase)
  	# メールアドレスを持つユーザーがデータベースに存在し、かつ入力されたパスワードがそのユーザーのパスワードである場合のみ、if文がtrueになる
  	# authenticateメソッド=引数の文字列がパスワードと一致するとUserオブジェクトを、間違っているとfalseを返すメソッド
  	if user && user.authenticate(params[:session][:password])
  		# ヘルパーでlog_inを定義している
  		log_in user
      # 三項演算子、remember meのチェックボックス
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      # フレンドリーフォワーディングのために設定
      redirect_back_or user
      # ログインしてユーザーを保持する
      # remember user
  		# プロフィールページuser_url(user)へのルーティング
  		# redirect_to user
  	else
  		# flash.nowのメッセージはその後リクエストが発生したときに消滅
  		flash.now[:danger] = 'Invalid email/password combination'
  		render 'new'
  	end
  end

  def destroy
    # ログイン中の場合のみログアウトする(複数タブでアプリケーションを開いている時のログアウトに対応)
    log_out if logged_in?
  	redirect_to root_url
  end
end
