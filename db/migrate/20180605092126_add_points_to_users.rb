class AddPointsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :user_counters, :points, :integer, default: 0, comment: '积分'
    add_column :user_counters, :share_count, :integer, default: 0, comment: '分享次数'
    add_index  :integrals, [:created_at]
    add_column :integrals, :category, :string, default: '', comment: '所属类别 任务，订单，平台赠送..'
    add_column :integrals, :active_at, :datetime, comment: '激活的时间'
    add_index  :integrals, :active_at
    remove_column  :integrals, :received_at
    add_index  :integrals, [:category]
  end
end
