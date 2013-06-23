class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :number
      t.string  :name
      t.string  :address
      t.float   :lat
      t.float   :lon
      t.float   :next_distance
      t.float   :total_distance
    end
    add_index :locations, :number, :unique => true
  end
end
