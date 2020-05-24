module SessionsHelper
# 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

# 現在ログイン中のユーザーを返す (いる場合)
  def current_user
    if session[:user_id]
    # ||=を用いた短縮形、丁寧に書くと以下の通り
    # if @current_user.nil?
  		# @current_user = User.find_by(id: session[:user_id])
	# else
	  # @current_user
	# end
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # 現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
