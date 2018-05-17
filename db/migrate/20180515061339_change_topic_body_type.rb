class ChangeTopicBodyType < ActiveRecord::Migration[5.1]
  def change
    remove_column :topics, :body
    add_column    :topics, :body, :text, comment: '话题的内容'
  end
end
