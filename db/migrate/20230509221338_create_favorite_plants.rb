class CreateFavoritePlants < ActiveRecord::Migration[7.0]
  def change
    create_table :favorite_plants do |t|
      t.references :user, null: false, foreign_key: true
      t.references :plant, null: false, foreign_key: true

      t.timestamps
    end
    add_index :favorite_plants, [:user_id, :plant_id], unique: true
  end
end
