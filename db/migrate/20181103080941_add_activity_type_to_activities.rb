class AddActivityTypeToActivities < ActiveRecord::Migration[5.1]
  def change
    add_column :activities, :activity_type, :string, default: 'normal', comment: '活动类别'
    add_index  :activities, [:activity_type]
  end
end
