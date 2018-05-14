class FollowerCountToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :followers_count, :integer, default: 0, comment: '粉丝数'
    add_column :users, :following_count, :integer, default: 0, comment: '关注数'
    add_column :users, :lat, :float
    add_column :users, :lng, :float
  end
end
