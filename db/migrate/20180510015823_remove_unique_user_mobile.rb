class RemoveUniqueUserMobile < ActiveRecord::Migration[5.1]
  def change
    remove_index :users, column: :email
    remove_index :users, column: :mobile
    remove_index :users, column: :nick_name

    add_index :users, :email
    add_index :users, :mobile
    add_index :users, :nick_name

    remove_column :users, :gender
    add_column    :users, :gender, :integer, default: 0, comment: '用户的性别, 0表示男， 1表示女, 2未知'
  end
end
