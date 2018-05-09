class AddUniqueToUserColumns < ActiveRecord::Migration[5.1]
  def change
    remove_index :users, column: [:user_uuid, :nick_name]
    remove_index :users, column: [:email, :mobile]

    add_index :users, :user_uuid, unique: true
    add_index :users, :user_name, unique: true
    add_index :users, :nick_name, unique: true
    add_index :users, :email,     unique: true
    add_index :users, :mobile,    unique: true
  end
end
