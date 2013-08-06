class AddRadianToUserStatuses < ActiveRecord::Migration
  def change
    add_column :user_statuses, :bearing, :integer
  end
end
