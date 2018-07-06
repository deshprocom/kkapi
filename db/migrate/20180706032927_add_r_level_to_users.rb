class AddRLevelToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :r_level, :integer, default: 0, comment: '用户级别'
  end
end
