class AddInviteCountToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :user_counters, :direct_invite_count, :integer, default: 0, comment: '直接邀请用户数'
    add_column :user_counters, :indirect_invite_count, :integer, default: 0, comment: '间接邀请用户数'
    add_column :user_counters, :direct_invite_money, :decimal, precision: 11, scale: 2, default: 0, comment: '直接邀请用户奖金'
    add_column :user_counters, :indirect_invite_money, :decimal, precision: 11, scale: 2, default: 0, comment: '间接邀请用户奖金'
  end
end
