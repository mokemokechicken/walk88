class AddColumnsToUserSettings < ActiveRecord::Migration
  def change
    add_column :user_settings, :fitbit_user_id, :string
    add_column :user_settings, :fitbit_token, :string
    add_column :user_settings, :fitbit_secret, :string
  end
end
