class AddFavoritesCountToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :infos, :favorites_count, :integer, default: 0, comment: '收藏数'
    add_column :hotels, :favorites_count, :integer, default: 0, comment: '收藏数'
    add_column :topics, :favorites_count, :integer, default: 0, comment: '收藏数'
  end
end
