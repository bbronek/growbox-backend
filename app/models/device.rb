class Device < ApplicationRecord
  belongs_to :user, optional: true
  has_many :device_logs, dependent: :destroy
  has_many :plants, dependent: :destroy
  has_one_attached :image
end
