module Api
  module V1
    class DeviceLogsController < BaseController
      before_action :authenticate_user!
      before_action :set_device, only: [:index, :show]

      api :GET, '/v1/device_logs', 'Get all device logs for a specific device'
      param :device_id, Integer, desc: 'ID of the device for which logs are to be shown', required: true
      def index
        @logs = @device.device_logs
        render json: @logs
      end

      api :GET, '/v1/device_logs/:id', 'Show details of a specific device log'
      param :device_id, Integer, desc: 'ID of the device to which the log belongs', required: true
      param :id, Integer, desc: 'ID of the log to be shown', required: true
      def show
        @log = @device.device_logs.find(params[:id])
        render json: @log
      end

      private

      def set_device
        @device = Device.find(params[:device_id])
      end
    end
  end
end
