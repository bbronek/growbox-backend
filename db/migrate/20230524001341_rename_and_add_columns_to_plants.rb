class RenameAndAddColumnsToPlants < ActiveRecord::Migration[7.0]
  def change
    rename_column :plants, :humidity_min, :air_humidity_min
    rename_column :plants, :humidity_max, :air_humidity_max
    add_column :plants, :soil_humidity_min, :float
    add_column :plants, :soil_humidity_max, :float
  end
end
