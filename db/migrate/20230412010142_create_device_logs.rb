class CreateDeviceLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :device_logs do |t|
      t.float :temp
      t.float :soil_hum
      t.float :air_hum
      t.float :light
      t.references :device, null: false, foreign_key: true

      t.timestamps
    end
  end
end
