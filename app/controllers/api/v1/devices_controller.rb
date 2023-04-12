module Api
  module V1
    class DevicesController < BaseController
      def index
        devices = current_user.devices
        render json: devices
      end

      def show
        device = current_user.devices.find(params[:id])
        render json: device
      end

      private
      # Change with jwt when frontend will be ready
      def current_user
        @current_user ||= User.find_by(id: params[:user_id])
      end
    end
  end
end
