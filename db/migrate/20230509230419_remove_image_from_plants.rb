class RemoveImageFromPlants < ActiveRecord::Migration[7.0]
  def change
    remove_column :plants, :image
  end
end
