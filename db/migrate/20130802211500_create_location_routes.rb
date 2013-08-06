class CreateLocationRoutes < ActiveRecord::Migration
  def change
    create_table :location_routes do |t|
      t.integer :start_id
      t.integer :end_id
      t.integer :distance
      t.string :polyline
    end
    add_index :location_routes, [:start_id, :end_id], :unique => true
  end
end
