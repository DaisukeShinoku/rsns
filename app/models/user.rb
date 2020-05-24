class User < ApplicationRecord
	# remember_token属性を直接変更して操作ができるようにする
	attr_accessor :remember_token
	# email属性を小文字に変更
	before_save { email.downcase! }
	# name 存在性and長さ
	validates :name, presence: true, length: {maximum: 50}
	# 定数でemailのフォーマットを設定（Rubyで大文字は定数を意味する）
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX },
	# この書き方でメールアドレスの大文字小文字を無視した一意性の検証が可能になる
	uniqueness: { case_sensitive: false}
	# has_secure_passwordの３つの役割
	# 1. ハッシュ化したパスワードをpassword_digestに保存できるようになる
	# 2. 存在性と値が一致するかどうかのバリデーション追加
	# 3. authenticateメソッド追加
	has_secure_password
	# 字数制限と存在性（上のメソッドでの存在性のバリデーションは更新時は適用されない）
	validates :password, presence: true, length: { minimum: 6 }

  # 渡された文字列のハッシュ値を返す、bcryptを使う
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # urlsafe_base64メソッドでランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    # 記憶ダイジェストを更新、バリデーションを素通りさせる
    # update_attributesメソッドは属性のハッシュを受け取り、成功時には更新と保存を続けて同時に行う
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
  # authenticated?を更新して、ダイジェストが存在しない場合(複数ブラウザSafariとChromeでのログアウト問題)に対応
  return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  # 以下のコードでも同じ意味
	# if remember_digest.nil?
  		# false
	# else
  		# BCrypt::Password.new(remember_digest).is_password?(remember_token)
	# end

  # ユーザーのログイン情報を破棄する
  def forget
  	# 記憶ダイジェストをnilで更新
    update_attribute(:remember_digest, nil)
  end
end
