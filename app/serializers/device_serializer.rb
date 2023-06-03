class DeviceSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :image_url
  has_many :plants

  def image_url
    rails_blob_url(object.image) if object.image.attached?
  end
end
