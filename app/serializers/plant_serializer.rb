class PlantSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :user_id, :device_id, :light_min, :light_max,
    :temp_min, :temp_max, :air_humidity_min, :air_humidity_max,
    :fertilizing, :repotting, :pruning, :common_diseases,
    :appearance, :blooming_time, :status, :created_at, :updated_at, :description, :soil_humidity_min,
    :soil_humidity_max, :attached_image_url, :image_url

  def attached_image_url
    rails_blob_url(object.image) if object.image.attached?
  end
end
