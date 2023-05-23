class CreatePlants < ActiveRecord::Migration[7.0]
  def change
    create_table :plants do |t|
      t.string :name, null: false
      t.references :user, null: false, foreign_key: true
      t.references :device, null: false, foreign_key: true
      t.float :light_min
      t.float :light_max
      t.float :temp_min
      t.float :temp_max
      t.float :humidity_min
      t.float :humidity_max
      t.text :fertilizing
      t.text :repotting
      t.text :pruning
      t.text :common_diseases
      t.text :appearance
      t.text :blooming_time
      t.string :image
      t.boolean :public

      t.timestamps
    end
  end
end
