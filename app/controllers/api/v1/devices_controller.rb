module Api
  module V1
    class DevicesController < BaseController
      before_action :authenticate_user!
      before_action :set_device, only: [:destroy, :update, :plants]

      def index
        devices = @current_user.devices
        render json: devices
      end

      def show
        device = @current_user.devices.find(params[:id])
        render json: device
      end

      def destroy
        @device.destroy
        render json: {message: "Device successfully deleted."}, status: :ok
      end

      def assign
        @device = Device.find(params[:id])

        @device.user = @current_user
        if @device.save
          render json: @device, status: :ok
        else
          render json: @device.errors, status: :unprocessable_entity
        end
      end

      def update
        if @device.update(device_params)
          render json: @device, status: :ok
        else
          render json: @device.errors, status: :unprocessable_entity
        end
      end

      def create
        device = Device.new(device_params)
        if device.save
          render json: device, status: :created
        else
          render json: device.errors, status: :unprocessable_entity
        end
      end

      def plants
        render json: @device.plants, each_serializer: PlantSerializer
      end

      private

      def set_device
        @device = @current_user.devices.find(params[:id])
      end

      def device_params
        params.require(:device).permit(:name)
      end
    end
  end
end
