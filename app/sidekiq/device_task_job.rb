class DeviceTaskJob
  include Sidekiq::Job
  include TokenProvider

  def perform(device_id, task_number, status)
    acess_token = obtain_access_token(device_id)
    return unless acess_token

    endpoint = 'https://python-microservice-api.greenmind.site/devices/tasks/add'
    uri = URI.parse(endpoint)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    headers = { 'Authorization' => "Bearer #{access_token}", 'Content-Type' => 'application/json' }

    request = Net::HTTP::Post.new(uri.path, headers)
    request.body = { task_number: task_number, status: status }.to_json

    http.request(request)
  end
end
