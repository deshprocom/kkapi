class CreateWheelTaskCounts < ActiveRecord::Migration[5.1]
  def change
    create_table :wheel_task_counts do |t|
      t.references :user
      t.date :date, comment: '日期'
      t.integer :share_count, default: 0, comment: '游戏分享次数'
      t.integer :invite_count, default: 0, comment: '成功邀请好友数'
      t.timestamps
    end
  end
end
