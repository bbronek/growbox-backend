module Api
  module V1
    class DevicesController < BaseController
      before_action :authenticate_user!
      before_action :set_device, only: [:destroy, :update, :plants]

      def index
        devices = @current_user.devices
        render json: devices, each_serializer: DeviceSerializer
      end

      def show
        device = @current_user.devices.find(params[:id])
        render json: device, serializer: DeviceSerializer
      end

      def destroy
        @device.destroy
        render json: {message: "Device successfully deleted."}, status: :ok
      end

      def assign
        @device = Device.find(params[:id])
        @device.user = @current_user
        if @device.save
          render json: @device, status: :ok, serializer: DeviceSerializer
        else
          render json: @device.errors, status: :unprocessable_entity
        end
      end

      def update
        if @device.update(device_params)
          render json: @device, status: :ok, serializer: DeviceSerializer
        else
          render json: @device.errors, status: :unprocessable_entity
        end
      end

      def create
        user = User.find_by(code: params[:code])

        if user
          device = Device.new(device_params.merge(user: user))

          if device.save
            new_code = generate_random_code
            user.update(code: new_code)

            render json: { device: device, new_code: new_code }, status: :created, serializer: DeviceSerializer
          else
            render json: device.errors, status: :unprocessable_entity
          end
        else
          render json: { message: 'Code not found', status: 'Not Found' }, status: :not_found
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
        params.require(:device).permit(:name, :image)
      end

      def generate_random_code
        charset = Array('A'..'Z') + Array('a'..'z') + Array('0'..'9')
        Array.new(6) { charset.sample }.join
      end
    end
  end
end
