module Api
  module V1
    class UsersController < BaseController
      before_action :authenticate_user!, only: %i[show show_code]

      api :GET, '/v1/users', 'Get all users'
      def index
        render json: User.all
      end

      api :GET, '/v1/users/:id', 'Show current user'
      def show
        render json: @current_user
      end

      api :GET, '/v1/users/show_code', 'Show code for the current user'
      def show_code
        render json: { code: @current_user.code }
      end

      api :POST, '/v1auth_code', 'Authenticate user by code'
      param :code, String, desc: 'User code', required: true
      def auth_code
        code = params[:code]
        user = User.find_by(code: code)

        if user
          render json: { message: 'Code exists', status: 'OK' }
        else
          render json: { message: 'Code not found', status: 'Not Found' }, status: :not_found
        end
      end

      api :POST, '/v1/users', 'Create an user'
      param :user, Hash, desc: 'User info', required: true do
        param :email, String, desc: 'Email', required: true
        param :password, String, desc: 'Password', required: true
        param :password_confirmation, String, desc: 'Password confirmation', required: true
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
