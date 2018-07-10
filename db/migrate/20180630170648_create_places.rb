class CreatePlaces < ActiveRecord::Migration[5.0]
  def change
    create_table :places do |t|
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state 
      t.string :country
      t.text :description 
      t.integer :price 
      t.string :home_type
      t.integer :accommodate
      t.integer :bed_rooms
      t.integer :bathrooms
      t.boolean :has_wifi
      t.float :latitude
      t.float :longitude
      t.boolean :active

      t.timestamps
    end
  end
end
