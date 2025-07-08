Rails.application.routes.draw do
  get "bingo_games/index"
  get "bingo_games/new"
  get "bingo_games/create"
  resources :passwords, param: :token
  resources :bingo_games, only: [ :index, :new, :create ]

  root "pages#index"

  get "/login", to: "sessions#new", as: :login
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/signup", to: "users#new", as: :signup
  post "/signup", to: "users#create"

  get "up" => "rails/health#show", as: :rails_health_check
end
