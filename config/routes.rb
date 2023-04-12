Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show, :create]

      post "login", to: "authentication#login"
      delete "logout", to: "authentication#logout"
    end
  end
end
