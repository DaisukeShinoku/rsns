Rails.application.routes.draw do
  get 'user/new'
  root 'homes#top'
  get 'homes/about'
end
