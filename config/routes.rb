Rails.application.routes.draw do
  apipie
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show, :create] do
        get 'show_code', on: :member
      end

      get 'auth_code', to: 'users#auth_code'

      post "login", to: "authentication#login"
      delete "logout", to: "authentication#logout"

      resources :devices, only: [:index, :show, :create, :destroy, :update], path: "/devices" do
        post :assign, on: :member
        get :plants, on: :member
        resources :device_logs, only: [:index, :show], shallow: true
      end

      get "plants/public", to: "plants#public_index"
      get "plants/assigned", to: "plants#assigned_index"
      get "plants/private", to: "plants#private_index"
      get "plants/private/:id", to: "plants#private_show"

      post "plants/:plant_id/favorite", to: "plants#add_to_favorites"
      delete "plants/:plant_id/favorite", to: "plants#remove_from_favorites"
      get "plants/favorites", to: "plants#favorite_plants"
      resources :plants, only: [:show, :create, :update, :destroy]

      namespace :python_microservice do
        resources :data, only: [] do
          collection do
            get '/:device_id', to: 'data#index'
            get 'get_devices', to: 'data#get_devices'
            post 'update_device_data/:device_id', to: 'data#update_device_data'
            get 'get_device_tasks/:device_id', to: 'data#get_device_tasks'
            get 'get_device_data_history/:device_id', to: 'data#get_device_data_history'
            post 'add_device_task/:device_id', to: 'data#add_device_task'
            put 'update_device_task/:device_id', to: 'data#update_device_task'
            post 'add_device', to: 'data#add_device'
            get 'get_data', to: 'data#get_data'
            get 'get_tasks', to: 'data#get_tasks'
            post 'schedule_device_task', to: 'data#schedule_device_task'
          end
        end
      end
    end
  end
end
