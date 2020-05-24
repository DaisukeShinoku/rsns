Rails.application.routes.draw do
  get 'sessions/new'
# ルートページを設定
  root 'homes#top'
# この書き方でURLを指定する
  get '/about', to: "homes#about"
# ユーザー登録用
  get '/signup', to: "users#new"
# ログイン機能
  get '/login', to: "sessions#new"
  post '/login', to: "sessions#create"
  delete '/logout', to: "sessions#destroy"
# RESTfulなUsersリソースで必要となるすべてのアクションが利用できるようになる
  resources:users
end
