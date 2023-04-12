module Api
  module V1
    class DeviceLogsController < BaseController
      before_action :set_device, only: [:index, :show]

      def index
        @logs = @device.device_logs
        render json: @logs
      end

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
