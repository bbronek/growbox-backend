module Api
  module V1
    class DevicesController < BaseController
      before_action :authenticate_user!, only: [:index, :show]
      def index
        devices = @current_user.devices
        render json: devices
      end

      def show
        device = @current_user.devices.find(params[:id])
        render json: device
      end
    end
  end
end
