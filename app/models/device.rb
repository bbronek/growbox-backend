class Device < ApplicationRecord
  belongs_to :user
  has_many :device_logs
end
