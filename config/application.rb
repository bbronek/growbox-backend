require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module GrowboxBackend
  class Application < Rails::Application
    config.load_defaults 7.0
    config.api_only = true
    config.active_storage.routes_prefix = "/rails/active_storage"
  end
end
