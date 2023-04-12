module Api
  module V1
    class UsersController < BaseController
      # uncomment after frontend will be ready
      # before_action :authenticate_user!, only: [:index, :show]

      def index
        render json: User.all
      end

      def show
        user = User.find(params[:id])
        render json: user
      end

      def create
        user = User.new(user_params)

        if user.save
          jwt_token = user.generate_jwt
          render json: {token: jwt_token}
        else
          render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
        end
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

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
  end
end
