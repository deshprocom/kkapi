class AddNewUserToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :new_user, :boolean, default: true, comment: '是否是新用户'
  end
end
