class ChangeUserIdToNullInDevices < ActiveRecord::Migration[7.0]
  def change
    change_column_null :devices, :user_id, true
  end
end
