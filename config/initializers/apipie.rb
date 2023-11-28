Apipie.configure do |config|
  config.app_name                = "GrowboxBackend"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/apipie"
  config.app_info                = "GreenMind API description"
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.validate = false
end
