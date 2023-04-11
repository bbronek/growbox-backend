module Api
  module V1
    class UsersController < BaseController
      before_action :authenticate_user!

      def index
        render json: User.all
      end

      def show
        user = User.find(params[:id])
        render json: user
      end

      private

      def authenticate_user!
        jwt_token = request.headers["Authorization"]&.split(" ")&.last
        if jwt_token && verify_jwt(jwt_token)
          @current_user = User.find(verify_jwt(jwt_token)["user_id"])
        else
          render json: {error: "Unauthorized"}, status: :unauthorized
        end
      end
    end
  end
end
