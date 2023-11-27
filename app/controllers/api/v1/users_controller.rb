module Api
  module V1
    class UsersController < BaseController
      before_action :authenticate_user!, only: [:show]

      def index
        render json: User.all
      end

      def show
        render json: @current_user
      end

      def create
        user = User.new(user_params)

        if user.save
          jwt_token = user.generate_jwt
          render json: { token: jwt_token }
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
  end
end
