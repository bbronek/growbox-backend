class AddStatusToPlants < ActiveRecord::Migration[7.0]
  def change
    add_column :plants, :status, :string, default: 'public'
  end
end
