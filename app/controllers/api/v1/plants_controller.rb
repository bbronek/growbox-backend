module Api
  module V1
    class PlantsController < BaseController
      before_action :authenticate_user!, only: [:private_index, :private_show, :create, :update, :destroy, :add_to_favorites, :remove_from_favorites, :favorite_plants]
      before_action :set_plant, only: [:show, :private_show, :update, :destroy]

      # Public CRUD actions
      def public_index
        @public_plants = Plant.where(public: true)
        render json: @public_plants, each_serializer: PlantSerializer
      end

      def show
        render json: @plant, serializer: PlantSerializer
      end

      # Private CRUD actions
      def private_index
        @private_plants = Plant.where(user_id: @current_user.id)
        render json: @private_plants, each_serializer: PlantSerializer
      end

      def private_show
        render json: @plant, serializer: PlantSerializer
      end

      def create
        @plant = Plant.new(plant_params.merge(user_id: @current_user.id))

        if @plant.save
          render json: @plant, serializer: PlantSerializer, status: :created
        else
          render json: @plant.errors, status: :unprocessable_entity
        end
      end

      def update
        if @plant.update(plant_params)
          render json: @plant, serializer: PlantSerializer
        else
          render json: @plant.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @plant.destroy
        head :no_content
      end

      def add_to_favorites
        favorite_plant = FavoritePlant.new(user_id: @current_user.id, plant_id: params[:plant_id])

        if favorite_plant.save
          render json: {message: "Plant added to favorites."}, status: :created
        else
          render json: favorite_plant.errors, status: :unprocessable_entity
        end
      end

      def remove_from_favorites
        favorite_plant = FavoritePlant.find_by(user_id: @current_user.id, plant_id: params[:plant_id])

        if favorite_plant&.destroy
          render json: {message: "Plant removed from favorites."}, status: :ok
        else
          render json: {error: "Failed to remove plant from favorites."}, status: :unprocessable_entity
        end
      end

      def favorite_plants
        @favorite_plants = User.find(@current_user.id).favorite_plants_list
        render json: @favorite_plants, each_serializer: PlantSerializer
      end

      private

      def set_plant
        @plant = Plant.find(params[:id])
      end

      def plant_params
        params.require(:plant).permit(:name, :device_id, :public, :light_min, :light_max, :temp_min, :temp_max, :air_humidity_min, :air_humidity_max, :soil_humidity_max, :soil_humidity_min,  :fertilizing, :repotting, :pruning, :common_diseases, :appearance, :blooming_time, :image)
      end
    end
  end
end
