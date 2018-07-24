class AddLevelSpecialToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :level_special, :string, default: '', comment: '用户特殊身份'
  end
end
