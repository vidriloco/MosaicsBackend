class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
      t.string :uid
      t.string :full_name, :null => false
      t.string :username, :null => false
      
      t.date :birthday
      t.integer :job
      t.string :phone
      t.integer :extension
      t.string :cell_phone
      
      t.integer :organization_id
      t.string :type
      t.timestamps
    end
    
    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
  end
end
