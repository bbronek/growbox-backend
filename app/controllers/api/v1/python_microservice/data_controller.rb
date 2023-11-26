# frozen_string_literal: true

require 'net/http'
require 'json'

module Api
  module V1
    module PythonMicroservice
      class DataController < BaseController
        include TokenProvider

        def get_devices
          devices_url = URI.parse('https://python-microservice-api.greenmind.site/devices')
          http = Net::HTTP.new(devices_url.host, devices_url.port)
          http.use_ssl = true

          devices_request = Net::HTTP::Get.new(devices_url.path)
          devices_response = http.request(devices_request)

          if devices_response.code.to_i == 200
            parsed_response = JSON.parse(devices_response.body)
            render json: parsed_response
          else
            render json: { error: 'Microservice error' }, status: devices_response.code.to_i
          end
        end

        def index
          device_id = params[:device_id]
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

        def update_device_data
          device_id = params[:device_id]
          access_token = obtain_access_token(device_id)

          if access_token
            update_data_url = URI.parse('https://python-microservice-api.greenmind.site/devices/data')
            http = Net::HTTP.new(update_data_url.host, update_data_url.port)
            http.use_ssl = true

            temp = params[:temp]
            soil_hum = params[:soil_hum]
            air_hum = params[:air_hum]
            light = params[:light]

            request_body = {
              temp: temp,
              soil_hum: soil_hum,
              air_hum: air_hum,
              light: light
            }.to_json

            headers = { 'Authorization' => "Bearer #{access_token}", 'Content-Type' => 'application/json' }

            update_data_request = Net::HTTP::Post.new(update_data_url.path, headers)
            update_data_request.body = request_body

            update_data_response = http.request(update_data_request)

            if update_data_response.code.to_i == 200
              parsed_response = JSON.parse(update_data_response.body)
              render json: parsed_response
            else
              render json: { error: 'Microservice error' }, status: update_data_response.code.to_i
            end
          else
            render json: { error: 'Failed to obtain access token' }, status: :unprocessable_entity
          end
        end

        def get_device_tasks
          device_id = params[:device_id]
          access_token = obtain_access_token(device_id)

          if access_token
            tasks_url = URI.parse('https://python-microservice-api.greenmind.site/devices/tasks')
            http = Net::HTTP.new(tasks_url.host, tasks_url.port)
            http.use_ssl = true

            headers = { 'Authorization' => "Bearer #{access_token}" }

            tasks_request = Net::HTTP::Get.new(tasks_url.path, headers)
            tasks_response = http.request(tasks_request)

            if tasks_response.code.to_i == 200
              parsed_response = JSON.parse(tasks_response.body)
              render json: parsed_response
            else
              render json: { error: 'Microservice error' }, status: tasks_response.code.to_i
            end
          else
            render json: { error: 'Failed to obtain access token' }, status: :unprocessable_entity
          end
        end

        def get_device_data_history
          device_id = params[:device_id]
          access_token = obtain_access_token(device_id)

          if access_token
            history_url = URI.parse('https://python-microservice-api.greenmind.site/devices/data/history')
            http = Net::HTTP.new(history_url.host, history_url.port)
            http.use_ssl = true

            headers = { 'Authorization' => "Bearer #{access_token}" }

            history_request = Net::HTTP::Get.new(history_url.path, headers)
            history_response = http.request(history_request)

            if history_response.code.to_i == 200
              parsed_response = JSON.parse(history_response.body)
              render json: parsed_response
            else
              render json: { error: 'Microservice error' }, status: history_response.code.to_i
            end
          else
            render json: { error: 'Failed to obtain access token' }, status: :unprocessable_entity
          end
        end

        def add_device_task
          device_id = params[:device_id]
          access_token = obtain_access_token(device_id)

          if access_token
            tasks_add_url = URI.parse('https://python-microservice-api.greenmind.site/devices/tasks/add')
            http = Net::HTTP.new(tasks_add_url.host, tasks_add_url.port)
            http.use_ssl = true

            task_number = params[:task_number]
            status = params[:status]

            request_body = {
              task_number: task_number,
              status: status
            }.to_json

            headers = { 'Authorization' => "Bearer #{access_token}", 'Content-Type' => 'application/json' }

            tasks_add_request = Net::HTTP::Post.new(tasks_add_url.path, headers)
            tasks_add_request.body = request_body

            tasks_add_response = http.request(tasks_add_request)

            if tasks_add_response.code.to_i == 200
              parsed_response = JSON.parse(tasks_add_response.body)
              render json: parsed_response
            else
              render json: { error: 'Microservice error' }, status: tasks_add_response.code.to_i
            end
          else
            render json: { error: 'Failed to obtain access token' }, status: :unprocessable_entity
          end
        end

        def update_device_task
          device_id = params[:device_id]
          access_token = obtain_access_token(device_id)

          if access_token
            task_id = params[:task_id]
            status = params[:status]

            tasks_update_url = URI.parse("https://python-microservice-api.greenmind.site/devices/tasks/update/#{task_id}")
            http = Net::HTTP.new(tasks_update_url.host, tasks_update_url.port)
            http.use_ssl = true

            request_body = {
              task_id: task_id,
              status: status
            }.to_json

            headers = { 'Authorization' => "Bearer #{access_token}", 'Content-Type' => 'application/json' }

            tasks_update_request = Net::HTTP::Put.new(tasks_update_url.path, headers)
            tasks_update_request.body = request_body

            tasks_update_response = http.request(tasks_update_request)

            if tasks_update_response.code.to_i == 200
              parsed_response = JSON.parse(tasks_update_response.body)
              render json: parsed_response
            else
              render json: { error: 'Microservice error' }, status: tasks_update_response.code.to_i
            end
          else
            render json: { error: 'Failed to obtain access token' }, status: :unprocessable_entity
          end
        end

        def add_device
          new_device_url = URI.parse('https://python-microservice-api.greenmind.site/add_device')
          http = Net::HTTP.new(new_device_url.host, new_device_url.port)
          http.use_ssl = true

          device_name = params[:device_name]
          location = params[:location]

          request_body = {
            device_name: device_name,
            location: location
          }.to_json

          headers = { 'Content-Type' => 'application/json' }

          new_device_request = Net::HTTP::Post.new(new_device_url.path, headers)
          new_device_request.body = request_body

          new_device_response = http.request(new_device_request)

          if new_device_response.code.to_i == 200
            parsed_response = JSON.parse(new_device_response.body)
            render json: parsed_response
          else
            render json: { error: 'Microservice error' }, status: new_device_response.code.to_i
          end
        end

        def get_data
          data_url = URI.parse('https://python-microservice-api.greenmind.site/data')
          http = Net::HTTP.new(data_url.host, data_url.port)
          http.use_ssl = true

          data_request = Net::HTTP::Get.new(data_url.path)
          data_response = http.request(data_request)

          if data_response.code.to_i == 200
            parsed_response = JSON.parse(data_response.body)
            render json: parsed_response
          else
            render json: { error: 'Microservice error' }, status: data_response.code.to_i
          end
        end

        def get_tasks
          tasks_url = URI.parse('https://python-microservice-api.greenmind.site/tasks')
          http = Net::HTTP.new(tasks_url.host, tasks_url.port)
          http.use_ssl = true

          tasks_request = Net::HTTP::Get.new(tasks_url.path)
          tasks_response = http.request(tasks_request)

          if tasks_response.code.to_i == 200
            parsed_response = JSON.parse(tasks_response.body)
            render json: parsed_response
          else
            render json: { error: 'Microservice error' }, status: tasks_response.code.to_i
          end
        end

      end
    end
  end
end
