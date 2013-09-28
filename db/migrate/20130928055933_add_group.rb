class AddGroup < ActiveRecord::Migration
  def change
    create_table(:groups) do |t|
      t.string :name
    end

    create_table(:group_users) do |t|
      t.integer :group_id
      t.integer :user_id
    end
  end
end
