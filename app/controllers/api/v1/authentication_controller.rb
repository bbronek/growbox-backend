module Api
  module V1
    class AuthenticationController < BaseController
      def login
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          jwt_token = user.generate_jwt
          render json: {token: jwt_token}
        else
          render json: {error: "Invalid email or password"}, status: :unauthorized
        end
      end

      def logout
        current_user.invalidate_token
        head :ok
      end

      private

      def current_user
        @current_user ||= User.find_by(id: payload["user_id"])
      end

      def payload
        @payload ||= JWT.decode(request.headers["Authorization"].split(" ")[1], Rails.application.secret_key_base, true)[0]
      end
    end
  end
end
