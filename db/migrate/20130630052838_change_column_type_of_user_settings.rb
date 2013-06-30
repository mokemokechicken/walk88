class ChangeColumnTypeOfUserSettings < ActiveRecord::Migration
  def change
    change_column :user_settings, :step_dist, :float
  end
end
