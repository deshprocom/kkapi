class AddNewUserToRelation < ActiveRecord::Migration[5.1]
  def change
    add_column :user_relations, :new_user, :boolean, default: true, comment: '是否是新用户'
    add_index :user_relations, :new_user
  end
end
