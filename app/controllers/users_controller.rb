class UsersController < ApplicationController
	# ユーザーにログインを要求
	before_action :logged_in_user, only: [:index, :edit, :update]
	# 本人以外にプロフ編集させない
	before_action :correct_user,   only: [:edit, :update]
	# destroyアクションを管理者だけに限定する
	before_action :admin_user,     only: :destroy

	def index
		@users = User.all
	end

	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			log_in @user
			flash[:success] = "ユーザー登録に成功しました！"
			# redirect_to user_url(@user)と同意、redirect_toの時はpathでなくurl、HTTPの標準としては、リダイレクトのときに完全なURLが要求される
			redirect_to @user
		else
			render 'new'
		end
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(user_parmas)
		else
			render 'edit'
		end
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success]  = "削除しました"
		redirect_to users_url
	end

 private
# 悪意のあるユーザが自身に管理者権限を付与するなどシステムを自由に操作できてしまう脆弱性を回避
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # beforeアクション

    # ログイン済みユーザーかどうか確認
    def logged_in_user
    	unless logged_in?
    		# フレンドリーフォワーディング（ユーザーが開こうとしていたページに誘導
    		store_location
    		flash[:danger] = "ログインしてください"
    		redirect_to login_url
    	end
    end

    # 正しいユーザーかどうか確認
    def correct_user
    	@user = User.find(params[:id])
    	redirect_to(root_url) unless current_user?(@user)
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
