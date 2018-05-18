class DropColumnFromUserId < ActiveRecord::Migration[5.1]
  def change
    remove_column :topic_notifications,   :from_user_id,  :integer, default: 0, comment: '回复数'
    add_column    :topic_notifications,   :target_id,     :integer
    add_column    :topic_notifications,   :target_type,   :string
  end
end
