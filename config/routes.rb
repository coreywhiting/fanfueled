Rails.application.routes.draw do
  get 'baseball_matchup/scrape'

  get 'baseball_matchup/update_teams'

  namespace :admin do
    resources :users
    root to: "users#index"
  end
  root to: 'visitors#index'
  devise_for :users
  resources :users
end
