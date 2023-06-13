class Plant < ApplicationRecord
  belongs_to :user
  belongs_to :device, optional: true

  has_one_attached :image

  validate :maximum_plants_per_device
  validates :status, inclusion: { in: %w(public private assigned) }

  private

  def maximum_plants_per_device
    return unless device&.plants&.count&.>= 3

    errors.add(:device, "can't have more than 3 plants")
  end
end
