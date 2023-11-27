module Api
  module V1
    class AuthenticationController < BaseController
      before_action :authenticate_user!, only: [:logout]

      api :POST, '/v1/login', 'Authenticate and obtain a JWT token'
      param :email, String, desc: 'User email', required: true
      param :password, String, desc: 'User password', required: true
      def login
        user = User.find_by(email: user_params[:email])
        if user&.authenticate(user_params[:password])
          jwt_token = user.generate_jwt
          render json: { token: jwt_token }
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end

      api :POST, '/v1/logout', 'Invalidate the JWT token and log out the user'
      def logout
        @current_user.invalidate_token
        head :ok
      end

      private

      def user_params
        params.permit(:email, :password)
      end
    end
  end
end
