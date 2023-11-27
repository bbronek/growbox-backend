# frozen_string_literal: true

require 'net/http'
require 'json'
require 'retriable'

module Api
  module V1
    module PythonMicroservice
      class PythonMicroserviceController < BaseController
        include TokenProvider

        MAX_RETRIES = 3
        RETRY_INTERVAL = 2
        REQUEST_TIMEOUT = 10

        api :GET, '/v1/python_microservice/get_devices', 'Get devices with caching'
        def get_devices
          cached_response = Rails.cache.read('devices_cache')

          if cached_response.nil?
            response = api_request { make_request('https://python-microservice-api.greenmind.site/devices') }
            Rails.cache.write('devices_cache', response, expires_in: 1.hour)
          else
            response = cached_response
          end

          render_response(response)
        end

        api :GET, '/v1/python_microservice/index', 'Get device data'
        param :device_id, String, desc: 'Device ID', required: true
        def index
          access_token = obtain_access_token(params[:device_id])
          return render_error('Failed to obtain access token') unless access_token

          endpoint = 'https://python-microservice-api.greenmind.site/devices/data'
          headers = { 'Authorization' => "Bearer #{access_token}", 'Content-Type' => 'application/json' }
          response = api_request { make_request(endpoint, headers) }
          render_response(response)
        end

        api :POST, '/v1/python_microservice/update_device_data', 'Update device data'
        param :device_id, String, desc: 'Device ID', required: true
        param :temp, String, desc: 'Temperature', required: true
        param :soil_hum, String, desc: 'Soil humidity', required: true
        param :air_hum, String, desc: 'Air humidity', required: true
        param :light, String, desc: 'Light intensity', required: true
        def update_device_data
          access_token = obtain_access_token(params[:device_id])
          return render_error('Failed to obtain access token') unless access_token

          endpoint = 'https://python-microservice-api.greenmind.site/devices/data'
          body = {
            temp: params[:temp],
            soil_hum: params[:soil_hum],
            air_hum: params[:air_hum],
            light: params[:light]
          }.to_json

          headers = { 'Authorization' => "Bearer #{access_token}", 'Content-Type' => 'application/json' }
          response = api_request { make_request(endpoint, headers, :post, body) }
          render_response(response)
        end

        api :GET, '/v1/python_microservice/get_device_tasks', 'Get device tasks'
        param :device_id, String, desc: 'Device ID', required: true
        def get_device_tasks
          access_token = obtain_access_token(params[:device_id])
          return render_error('Failed to obtain access token') unless access_token

          endpoint = 'https://python-microservice-api.greenmind.site/devices/tasks'
          headers = { 'Authorization' => "Bearer #{access_token}" }
          response = api_request { make_request(endpoint, headers) }
          render_response(response)
        end

        api :GET, '/v1/python_microservice/get_device_data_history', 'Get device data history'
        param :device_id, String, desc: 'Device ID', required: true
        def get_device_data_history
          access_token = obtain_access_token(params[:device_id])
          return render_error('Failed to obtain access token') unless access_token

          endpoint = 'https://python-microservice-api.greenmind.site/devices/data/history'
          headers = { 'Authorization' => "Bearer #{access_token}" }
          response = api_request { make_request(endpoint, headers) }
          render_response(response)
        end

        api :POST, '/v1/python_microservice/add_device_task', 'Add device task'
        param :device_id, String, desc: 'Device ID', required: true
        param :task_number, String, desc: 'Task number', required: true
        param :status, String, desc: 'Task status', required: true
        def add_device_task
          access_token = obtain_access_token(params[:device_id])
          return render_error('Failed to obtain access token') unless access_token

          endpoint = 'https://python-microservice-api.greenmind.site/devices/tasks/add'
          body = { task_number: params[:task_number], status: params[:status] }.to_json

          headers = { 'Authorization' => "Bearer #{access_token}", 'Content-Type' => 'application/json' }
          response = api_request { make_request(endpoint, headers, :post, body) }
          render_response(response)
        end

        api :PUT, '/v1/python_microservice/update_device_task', 'Update device task'
        param :device_id, String, desc: 'Device ID', required: true
        param :task_id, String, desc: 'Task ID', required: true
        param :status, String, desc: 'Task status', required: true
        def update_device_task
          access_token = obtain_access_token(params[:device_id])
          return render_error('Failed to obtain access token') unless access_token

          endpoint = "https://python-microservice-api.greenmind.site/devices/tasks/update/#{params[:task_id]}"
          body = { task_id: params[:task_id], status: params[:status] }.to_json

          headers = { 'Authorization' => "Bearer #{access_token}", 'Content-Type' => 'application/json' }
          response = api_request { make_request(endpoint, headers, :put, body) }
          render_response(response)
        end

        api :POST, '/v1/python_microservice/add_device', 'Add device'
        param :device_name, String, desc: 'Device name', required: true
        param :location, String, desc: 'Device location', required: true
        def add_device
          endpoint = 'https://python-microservice-api.greenmind.site/add_device'
          body = { device_name: params[:device_name], location: params[:location] }.to_json

          headers = { 'Content-Type' => 'application/json' }
          response = api_request { make_request(endpoint, headers, :post, body) }
          render_response(response)
        end

        api :GET, '/v1/python_microservice/get_data', 'Get microservice data'
        def get_data
          endpoint = 'https://python-microservice-api.greenmind.site/data'
          response = api_request { make_request(endpoint) }
          render_response(response)
        end

        api :GET, '/v1/python_microservice/get_tasks', 'Get microservice tasks'
        def get_tasks
          endpoint = 'https://python-microservice-api.greenmind.site/tasks'
          response = api_request { make_request(endpoint) }
          render_response(response)
        end

        private

        def api_request(&block)
          Retriable.retriable(on: [StandardError], tries: MAX_RETRIES, base_interval: RETRY_INTERVAL) do
            block.call
          end
        end

        def make_request(url, headers = {}, method = :get, body = nil)
          uri = URI.parse(url)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.read_timeout = REQUEST_TIMEOUT

          case method
          when :get
            request = Net::HTTP::Get.new(uri.path, headers)
          when :post
            request = Net::HTTP::Post.new(uri.path, headers)
            request.body = body
          when :put
            request = Net::HTTP::Put.new(uri.path, headers)
            request.body = body
          end

          response = http.request(request)
          { code: response.code.to_i, body: JSON.parse(response.body) }
        rescue StandardError => e
          { code: 500, body: { error: "Microservice error: #{e.message}", method: method, status_code: response.code.to_i } }
        end

        def render_response(response)
          if response[:code] == 200
            render json: response[:body]
          else
            render_error(response[:body]['error'], response[:code])
          end
        end

        def render_error(message, status = :unprocessable_entity)
          render json: { error: message, method: params[:action], status_code: status }, status: status
        end
      end
    end
  end
end
