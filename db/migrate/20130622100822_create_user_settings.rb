class CreateUserSettings < ActiveRecord::Migration
  def change
    create_table :user_settings do |t|
      t.integer :step_dist

      t.timestamps
    end
  end
end
