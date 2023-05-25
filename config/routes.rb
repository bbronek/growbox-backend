Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show, :create]

      post "login", to: "authentication#login"
      delete "logout", to: "authentication#logout"

      resources :devices, only: [:index, :show, :create, :destroy, :update], path: "/devices" do
        post :assign, on: :member
        resources :device_logs, only: [:index, :show], shallow: true
      end

      get "plants/public", to: "plants#public_index"
      get "plants/private", to: "plants#private_index"
      get "plants/private/:id", to: "plants#private_show"
      resources :plants, only: [:show, :create, :update, :destroy]

      post "plants/:plant_id/favorite", to: "plants#add_to_favorites"
      delete "plants/:plant_id/favorite", to: "plants#remove_from_favorites"
      get "plants/favorites", to: "plants#favorite_plants"

      namespace :python_microservice do
        resources :data, only: [:index]
      end
    end
  end
end
