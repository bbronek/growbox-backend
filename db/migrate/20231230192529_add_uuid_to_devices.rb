class AddUuidToDevices < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'uuid-ossp'
    add_column :devices, :uuid, :uuid, default: -> { "uuid_generate_v4()" }
  end
end
