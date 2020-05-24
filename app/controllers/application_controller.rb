class ApplicationController < ActionController::Base
	# Rails5.2以降ではActionController::Base内でprotect_from_forgery有効
	# セッション用ヘルパーの読み込み
    include SessionsHelper
end
