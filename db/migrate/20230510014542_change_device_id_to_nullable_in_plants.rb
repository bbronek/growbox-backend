class ChangeDeviceIdToNullableInPlants < ActiveRecord::Migration[7.0]
  def change
    change_column :plants, :device_id, :integer, null: true
  end
end
