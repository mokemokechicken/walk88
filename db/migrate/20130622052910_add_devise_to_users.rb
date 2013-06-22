class AddDeviseToUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      ##Omniauthable
      t.string :uid
      t.string :nickname
      t.string :provider
      t.string :image, :length => 512
      t.string :token
      t.integer :expires_at

      t.timestamps
    end
    add_index :users, :uid,  :unique => true
  end
end

