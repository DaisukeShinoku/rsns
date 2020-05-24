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
  		# プロフィールページuser_url(user)へのルーティング
  		redirect_to user
  	else
  		# flash.nowのメッセージはその後リクエストが発生したときに消滅
  		flash.now[:danger] = 'Invalid email/password combination'
  		render 'new'
  	end
  end

  def destroy
  	log_out
  	redirect_to root_url
  end
end
