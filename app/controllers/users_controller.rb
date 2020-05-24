class UsersController < ApplicationController
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

 private
# 悪意のあるユーザが自身に管理者権限を付与するなどシステムを自由に操作できてしまう脆弱性を回避
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
