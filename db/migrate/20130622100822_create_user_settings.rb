class CreateUserSettings < ActiveRecord::Migration
  def change
    create_table :user_settings do |t|
      t.integer :user_id
      t.integer :step_dist
      t.timestamps
    end
  end
end
