module Api
  module V1
    class UsersController < BaseController
      before_action :authenticate_user!, only: %i[show show_code]

      def index
        render json: User.all
      end

      def show
        render json: @current_user
      end

      def show_code
        render json: { code: @current_user.code }
      end

      def auth_code
        code = params[:code]
        user = User.find_by(code:)

        if user
          render json: { message: 'Code exists', status: 'OK' }
        else
          render json: { message: 'Code not found', status: 'Not Found' }, status: :not_found
        end
      end

      def create
        user = User.new(user_params)
        user.code = generate_random_code

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

      def generate_random_code
        charset = Array('A'..'Z') + Array('a'..'z') + Array('0'..'9')
        Array.new(6) { charset.sample }.join
      end
    end
  end
end
