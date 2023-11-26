module TokenProvider
  extend ActiveSupport::Concern

  included do
    def obtain_access_token(device_id)
      request_token_url = URI.parse('https://python-microservice-api.greenmind.site/request_token')
      request_body = { device_id: device_id }.to_json

      request_token_response = Net::HTTP.post(request_token_url, request_body, { 'Content-Type' => 'application/json' })

      return unless request_token_response.code.to_i == 200

      JSON.parse(request_token_response.body)['access_token']
    end
  end
end
