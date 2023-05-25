class Device < ApplicationRecord
  belongs_to :user, optional: true
  has_many :device_logs
  has_many :plants
end
