module Api
  module V1
    class BaseController < ApplicationController
      include JwtToken

      def authenticate_user!
        jwt_token = request.headers["Authorization"]&.split(" ")&.last
        if jwt_token && decode_jwt(jwt_token)
          @current_user = User.find(decode_jwt(jwt_token)["user_id"])
        else
          render json: {error: "Unauthorized"}, status: :unauthorized
        end
      end
    end
  end
end
