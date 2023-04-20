class RemoveLoginFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :login, :string
  end
end
