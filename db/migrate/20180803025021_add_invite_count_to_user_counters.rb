class AddInviteCountToUserCounters < ActiveRecord::Migration[5.1]
  def change
    add_column :user_counters, :invite_users, :integer, default: 0, comment: '直接邀请数，不管是否完成任务都统计'
  end
end
