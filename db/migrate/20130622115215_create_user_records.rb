class CreateUserRecords < ActiveRecord::Migration
  def change
    create_table :user_records do |t|
      t.integer :user_id
      t.date :day
      t.integer :steps
      t.float :distance

      t.timestamps
    end
    add_index :user_records, [:user_id, :day], :unique => true
  end
end
