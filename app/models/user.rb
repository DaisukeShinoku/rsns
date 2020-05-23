class User < ApplicationRecord
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
end
