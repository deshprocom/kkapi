class AddIsWheelToActivities < ActiveRecord::Migration[5.1]
  def change
    add_column(:activities, :is_wheel, :boolean, default: false, comment: '是否是大转盘活动')
    add_index :activities, :is_wheel
  end
end
