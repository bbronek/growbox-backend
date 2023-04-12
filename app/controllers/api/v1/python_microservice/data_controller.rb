require "httparty"

module Api
  module V1
    module PythonMicroservice
      class DataController < BaseController
        def index
          response = HTTParty.get("http://growbox.atthost24.pl/data")
          parsed_response = JSON.parse(response.body)
          render json: parsed_response
        end
      end
    end
  end
end
