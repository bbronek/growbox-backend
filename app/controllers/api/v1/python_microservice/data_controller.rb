# frozen_string_literal: true

require 'net/http'
require 'json'

module Api
  module V1
    module PythonMicroservice
      class DataController < BaseController
        include TokenProvider

        def index
          device_id = params[:device_id]  # Extract device_id from request parameters or wherever it's coming from
          access_token = obtain_access_token(device_id)

          if access_token
            devices_data_url = URI.parse('https://python-microservice-api.greenmind.site/devices/data')
            http = Net::HTTP.new(devices_data_url.host, devices_data_url.port)
            http.use_ssl = true

            headers = { 'Authorization' => "Bearer #{access_token}", 'Content-Type' => 'application/json' }

            devices_data_request = Net::HTTP::Get.new(devices_data_url.path, headers)
            devices_data_response = http.request(devices_data_request)

            if devices_data_response.code.to_i == 200
              parsed_response = JSON.parse(devices_data_response.body)
              render json: parsed_response
            else
              render json: { error: 'Microservice error' }, status: devices_data_response.code.to_i
            end
          else
            render json: { error: 'Failed to obtain access token' }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
