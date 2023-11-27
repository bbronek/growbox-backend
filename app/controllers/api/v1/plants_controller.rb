module Api
  module V1
    class PlantsController < BaseController
      before_action :authenticate_user!, only: [:assigned_index, :private_index, :private_show, :create, :update, :destroy, :add_to_favorites, :remove_from_favorites, :favorite_plants]
      before_action :set_plant, only: [:show, :private_show, :update, :destroy]

      api :GET, '/v1/plants/public_index', 'Get all public plants'
      def public_index
        @public_plants = Plant.where(status: 'public')
        render json: @public_plants, each_serializer: PlantSerializer
      end

      api :GET, '/v1/plants/:id', 'Show details of a plant'
      def show
        render json: @plant, serializer: PlantSerializer
      end

      api :GET, '/v1/plants/private_index', 'Get all private plants of the current user'
      def private_index
        @private_plants = Plant.where(user_id: @current_user.id, status: 'private')
        render json: @private_plants, each_serializer: PlantSerializer
      end

      api :GET, '/v1/plants/private_show/:id', 'Show details of a private plant'
      def private_show
        render json: @plant, serializer: PlantSerializer
      end

      api :GET, '/v1/plants/assigned_index', 'Get all assigned plants of the current user'
      def assigned_index
        @assigned_plants = Plant.where(user_id: @current_user.id, status: 'assigned')
        render json: @assigned_plants, each_serializer: PlantSerializer
      end

      api :POST, '/v1/plants', 'Create a new plant'
      param :plant, Hash, desc: 'Plant info', required: true do
        param :name, String, desc: 'Name of the plant', required: true
        param :device_id, Integer, desc: 'ID of the device associated with the plant'
        param :status, String, desc: 'Status of the plant (public/private/assigned)', required: true
        param :light_min, Integer, desc: 'Minimum light requirement for the plant'
        param :light_max, Integer, desc: 'Maximum light requirement for the plant'
        param :temp_min, Integer, desc: 'Minimum temperature requirement for the plant'
        param :temp_max, Integer, desc: 'Maximum temperature requirement for the plant'
        param :air_humidity_min, Integer, desc: 'Minimum air humidity requirement for the plant'
        param :air_humidity_max, Integer, desc: 'Maximum air humidity requirement for the plant'
        param :soil_humidity_min, Integer, desc: 'Minimum soil humidity requirement for the plant'
        param :soil_humidity_max, Integer, desc: 'Maximum soil humidity requirement for the plant'
        param :fertilizing, String, desc: 'Fertilizing details for the plant'
        param :repotting, String, desc: 'Repotting details for the plant'
        param :pruning, String, desc: 'Pruning details for the plant'
        param :common_diseases, String, desc: 'Common diseases for the plant'
        param :appearance, String, desc: 'Appearance details for the plant'
        param :blooming_time, String, desc: 'Blooming time for the plant'
        param :image, String, desc: 'Image data for the plant'
        param :image_url, String, desc: 'URL of the image for the plant'
      end
      def create
        @plant = Plant.new(plant_params.merge(user_id: @current_user.id))

        if @plant.save
          render json: @plant, serializer: PlantSerializer, status: :created
        else
          render json: @plant.errors, status: :unprocessable_entity
        end
      end

      api :PUT, '/v1/plants/:id', 'Update a plant'
      param :id, Integer, desc: 'ID of the plant to be updated', required: true
      param :plant, Hash, desc: 'Plant info', required: true do
        param :name, String, desc: 'Name of the plant'
        param :device_id, Integer, desc: 'ID of the device associated with the plant'
        param :status, String, desc: 'Status of the plant (public/private/assigned)'
        param :light_min, Integer, desc: 'Minimum light requirement for the plant'
        param :light_max, Integer, desc: 'Maximum light requirement for the plant'
        param :temp_min, Integer, desc: 'Minimum temperature requirement for the plant'
        param :temp_max, Integer, desc: 'Maximum temperature requirement for the plant'
        param :air_humidity_min, Integer, desc: 'Minimum air humidity requirement for the plant'
        param :air_humidity_max, Integer, desc: 'Maximum air humidity requirement for the plant'
        param :soil_humidity_min, Integer, desc: 'Minimum soil humidity requirement for the plant'
        param :soil_humidity_max, Integer, desc: 'Maximum soil humidity requirement for the plant'
        param :fertilizing, String, desc: 'Fertilizing details for the plant'
        param :repotting, String, desc: 'Repotting details for the plant'
        param :pruning, String, desc: 'Pruning details for the plant'
        param :common_diseases, String, desc: 'Common diseases for the plant'
        param :appearance, String, desc: 'Appearance details for the plant'
        param :blooming_time, String, desc: 'Blooming time for the plant'
        param :image, String, desc: 'Image data for the plant'
        param :image_url, String, desc: 'URL of the image for the plant'
      end
      def update
        if @plant.update(plant_params)
          render json: @plant, serializer: PlantSerializer
        else
          render json: @plant.errors, status: :unprocessable_entity
        end
      end

      api :DELETE, '/v1/plants/:id', 'Delete a plant'
      param :id, Integer, desc: 'ID of the plant to be deleted', required: true
      def destroy
        @plant.destroy
        head :no_content
      end

      api :POST, '/v1/plants/add_to_favorites', 'Add a plant to favorites'
      param :plant_id, Integer, desc: 'ID of the plant to be added to favorites', required: true
      def add_to_favorites
        favorite_plant = FavoritePlant.new(user_id: @current_user.id, plant_id: params[:plant_id])

        if favorite_plant.save
          render json: { message: 'Plant added to favorites.' }, status: :created
        else
          render json: favorite_plant.errors, status: :unprocessable_entity
        end
      end

      api :POST, '/v1/plants/remove_from_favorites', 'Remove a plant from favorites'
      param :plant_id, Integer, desc: 'ID of the plant to be removed from favorites', required: true
      def remove_from_favorites
        favorite_plant = FavoritePlant.find_by(user_id: @current_user.id, plant_id: params[:plant_id])

        if favorite_plant&.destroy
          render json: { message: 'Plant removed from favorites.' }, status: :ok
        else
          render json: { error: 'Failed to remove plant from favorites.' }, status: :unprocessable_entity
        end
      end

      api :GET, '/v1/plants/favorite_plants', 'Get all favorite plants of the current user'
      def favorite_plants
        @favorite_plants = User.find(@current_user.id).favorite_plants_list
        render json: @favorite_plants, each_serializer: PlantSerializer
      end

      private

      def set_plant
        @plant = Plant.find(params[:id])
      end

      def plant_params
        params.require(:plant).permit(:name, :device_id, :status, :light_min, :light_max, :temp_min, :temp_max, :air_humidity_min, :air_humidity_max, :soil_humidity_max, :soil_humidity_min, :fertilizing, :repotting, :pruning, :common_diseases, :appearance, :blooming_time, :image, :image_url)
      end
    end
  end
end
