module SessionsHelper
# 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # ユーザーのセッションを永続的にする、cookiesメソッドでユーザーIDと記憶トークンの永続cookiesを作成
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end

# 現在ログイン中のユーザーを返す (いる場合)
  def current_user
    # (ユーザーIDにユーザーIDのセッションを代入した結果) ユーザーIDのセッションが存在すれば
    if (user_id = session[:user_id])
    # ||=を用いた短縮形、丁寧に書くと以下の通り
    # if @current_user.nil?
  		# @current_user = User.find_by(id: session[:user_id])
	# else
	  # @current_user
	# end
      @current_user ||= User.find_by(id: session[:user_id])
    # 記憶トークンcookieに対応するユーザーを返す
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        # cookies[:user_id]からユーザーを取り出して、対応する永続セッションにログイン
        log_in user
        @current_user = user
      end
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

  # 永続的セッションを破棄する
  def forget(user)
    # user.forgetを呼んでからuser_idとremember_tokenのcookiesを削除
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # 記憶したURL (もしくはデフォルト値) にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく(getリクエストの時だけ)
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
