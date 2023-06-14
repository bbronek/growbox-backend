class AddImageUrlToPlants < ActiveRecord::Migration[7.0]
  def change
    add_column :plants, :image_url, :string, default: nil
  end
end
