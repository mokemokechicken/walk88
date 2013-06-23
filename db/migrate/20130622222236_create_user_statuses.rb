class CreateUserStatuses < ActiveRecord::Migration
  def change
    create_table :user_statuses do |t|
      t.integer :user_id
      t.integer :total_step, :default => 0
      t.float :total_distance, :default => 0
      t.float :lat
      t.float :lon
      t.integer :location_id
      t.integer :next_location_id
      t.float :next_distance
      t.date :last_walk_day
      t.timestamps
    end

    add_index :user_statuses, :user_id, :unique => true
  end
end
