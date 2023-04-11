module Api
  module V1
    class BaseController < ApplicationController
      include JwtToken
    end
  end
end
