require 'net/http'
require 'json'

module Api
  module V1
    module PythonMicroservice
      class DataController < BaseController
        def index
          request_token_url = URI.parse("https://python-microservice-api.greenmind.site/request_token")
          device_id = params[:device_id]

          request_token_response = Net::HTTP.post(request_token_url, { device_id: device_id }.to_json, { 'Content-Type' => 'application/json' })
          request_token = JSON.parse(request_token_response.body)['access_token']

          devices_data_url = URI.parse("https://python-microservice-api.greenmind.site/devices/data")
          http = Net::HTTP.new(devices_data_url.host, devices_data_url.port)
          http.use_ssl = true

          headers = { 'Authorization' => "Bearer #{request_token}", 'Content-Type' => 'application/json' }

          devices_data_request = Net::HTTP::Get.new(devices_data_url.path, headers)
          devices_data_response = http.request(devices_data_request)

          if devices_data_response.code.to_i == 200
            parsed_response = JSON.parse(devices_data_response.body)
            render json: parsed_response
          else
            render json: { error: 'Microservice error' }, status: devices_data_response.code.to_i
          end
        end
      end
    end
  end
end
