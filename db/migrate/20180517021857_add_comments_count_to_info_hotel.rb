class AddCommentsCountToInfoHotel < ActiveRecord::Migration[5.1]
  def change
    add_column :hotels,   :comments_count, :integer, default: 0, comment: '评论数'
    add_column :hotels,   :replies_count,  :integer, default: 0, comment: '回复数'

    add_column :infos,   :comments_count, :integer, default: 0, comment: '评论数'
    add_column :infos,   :replies_count,  :integer, default: 0, comment: '回复数'

    remove_column :topics, :images
    add_column    :topics, :images, :text, comment: '图片集合'
  end
end
