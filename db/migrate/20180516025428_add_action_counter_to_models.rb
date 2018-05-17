class AddActionCounterToModels < ActiveRecord::Migration[5.1]
  def change
    add_column :infos,    :likes_count,    :integer, default: 0, comment: '喜欢数'
    add_column :hotels,   :likes_count,    :integer, default: 0, comment: '喜欢数'
    add_column :topics,   :comments_count, :integer, default: 0, comment: '评论数'
    add_column :topics,   :replies_count,  :integer, default: 0, comment: '回复数'
    remove_column :topic_counters,   :comments,  :integer, default: 0, comment: '回复数'
  end
end
