Rails.application.routes.draw do
  resources :passwords, param: :token

  root "pages#index"

  get "/login", to: "sessions#new", as: :login
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/signup", to: "users#new", as: :signup
  post "/signup", to: "users#create"

  get "up" => "rails/health#show", as: :rails_health_check
end
