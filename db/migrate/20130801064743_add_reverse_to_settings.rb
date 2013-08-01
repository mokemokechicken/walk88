class AddReverseToSettings < ActiveRecord::Migration
  def change
    add_column :user_settings, :reverse_mode, :integer
  end
end
