module Api
  module V1
    class DevicesController < BaseController
      before_action :authenticate_user!, except: :create
      before_action :set_device, only: [:destroy, :update, :plants]

      include TokenProvider

      api :GET, '/v1/devices', 'Get all devices of the current user'
      def index
        devices = @current_user.devices
        render json: devices, each_serializer: DeviceSerializer
      end

      api :GET, '/v1/devices/:id', 'Show details of a specific device'
      param :id, Integer, desc: 'ID of the device to be shown', required: true
      def show
        device = @current_user.devices.find(params[:id])
        render json: device, serializer: DeviceSerializer
      end

      api :DELETE, '/v1/devices/:id', 'Delete a device'
      param :id, Integer, desc: 'ID of the device to be deleted', required: true
      def destroy
        uuid = @device.uuid

        access_token = obtain_access_token(uuid)

        if access_token
          delete_device_url = URI.parse('https://python-microservice-api.greenmind.site/delete_device')

          http = Net::HTTP.new(delete_device_url.host, delete_device_url.port)
          http.use_ssl = true

          request = Net::HTTP::Delete.new(delete_device_url.path, { 'Content-Type' => 'application/json' })
          request['Authorization'] = "Bearer #{access_token}"

          response = http.request(request)

          if response.code.to_i == 200
            @device.destroy
            render json: { message: 'Device successfully deleted and removed from the external service.' }, status: :ok
          else
            render json: { error: 'Error while destroying device on the external service.' }, status: :unprocessable_entity
          end
        else
          render json: { error: 'Unable to obtain access token. Device deletion aborted.' }, status: :unprocessable_entity
        end
      end

      api :POST, '/v1/devices/assign', 'Assign a device to the current user'
      param :id, Integer, desc: 'ID of the device to be assigned', required: true
      def assign
        @device = Device.find(params[:id])
        @device.user = @current_user
        if @device.save
          render json: @device, status: :ok, serializer: DeviceSerializer
        else
          render json: @device.errors, status: :unprocessable_entity
        end
      end

      api :PUT, '/v1/devices/:id', 'Update a device'
      param :id, Integer, desc: 'ID of the device to be updated', required: true
      param :device, Hash, desc: 'Device info', required: true do
        param :name, String, desc: 'Name of the device'
        param :image, String, desc: 'Image data for the device'
      end
      def update
        if @device.update(device_params)
          render json: @device, status: :ok, serializer: DeviceSerializer
        else
          render json: @device.errors, status: :unprocessable_entity
        end
      end

      api :POST, '/v1/devices', 'Create a new device'
      param :code, String, desc: 'User\'s code', required: true
      param :device_id, Integer, desc: 'Device ID', required: true
      def create
        user = User.find_by(code: params[:code])

        if user
          device = Device.new(uuid: params[:uuid], user: user)

          if device.save
            new_code = generate_random_code
            user.update_attribute(:code, new_code)
            render json: { device: device }, status: :created
          else
            render json: device.errors, status: :unprocessable_entity
          end

        else
          render json: { message: 'Code not found', status: 'Not Found' }, status: :not_found
        end
      end

      api :GET, '/v1/devices/:id/plants', 'Get all plants associated with a specific device'
      param :id, Integer, desc: 'ID of the device for which plants are to be shown', required: true
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
