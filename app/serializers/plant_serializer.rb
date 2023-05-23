class PlantSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :user_id, :device_id, :light_min, :light_max,
    :temp_min, :temp_max, :humidity_min, :humidity_max,
    :fertilizing, :repotting, :pruning, :common_diseases,
    :appearance, :blooming_time, :public, :created_at, :updated_at, :description, :image_url

  def image_url
    rails_blob_url(object.image) if object.image.attached?
  end
end
