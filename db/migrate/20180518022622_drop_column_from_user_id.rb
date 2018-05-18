class DropColumnFromUserId < ActiveRecord::Migration[5.1]
  def change
    remove_column :topic_notifications,   :from_user_id,  :integer, default: 0, comment: '回复数'
    add_column    :topic_notifications,   :target_id,     :integer
    add_column    :topic_notifications,   :target_type,   :string
    add_index :topic_notifications, [:user_id, :read_at]
    add_index :topic_notifications, [:notify_type, :target_id, :target_type], name: 'topic_notification_notify_target'
  end
end
