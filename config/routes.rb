Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  get "/api/:version/docs", to: "api_docs#index"

  namespace :v1 do
    post "register", to: "users/registrations#create"
    post "login", to: "users/authentications#create"
    post "logout", to: "users/authentications#destroy"

    resources :expenses, only: [ :index, :create, :destroy ]
    resources :users, only: [ :show ]
  end
end
