class AddIndexToUserExtras < ActiveRecord::Migration[5.1]
  def change
    remove_column :user_extras, :deleted
    add_column    :user_extras, :deleted_at, :datetime, comment: '删除时间'
    add_index     :user_extras, :deleted_at
    add_index     :user_extras, :cert_type
    add_index     :user_extras, :status
  end
end
