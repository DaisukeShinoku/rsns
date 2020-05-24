Rails.application.routes.draw do
# ルートページを設定
  root 'homes#top'
# この書き方でURLを指定する
  get '/about', to: "homes#about"
# ユーザー登録用
  get '/signup', to: "users#new"
# RESTfulなUsersリソースで必要となるすべてのアクションが利用できるようになる
  resources:users
end
