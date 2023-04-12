Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show, :create]

      post "login", to: "authentication#login"
      delete "logout", to: "authentication#logout"

      resources :devices, only: [:index, :show], path: "users/:user_id/devices" do
        resources :device_logs, only: [:index, :show], shallow: true
      end

      namespace :python_microservice do
        resources :data, only: [:index]
      end
    end
  end
end
