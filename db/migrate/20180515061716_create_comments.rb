class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.references :user
      t.string   :target_type,    comment: '评论的对象'
      t.integer  :target_id,      comment: '评论的对象ID'
      t.text     :body,           comment: '评论的内容'
      t.datetime :deleted_at,     comment: '删除时间'
      t.string   :deleted_reason, comment: '删除的原因'
      t.boolean  :excellent,      default: false,     comment: '是否加精华'
      t.integer  :replies_count,    default: 0,         commnet: '评论下面回复的数量'
      t.timestamps
    end
    add_index :comments, [:target_type, :target_id]
    add_index :comments, [:deleted_at]

    create_table :replies do |t|
      t.references :user
      t.text       :body,           comment: '回复的内容'
      t.integer    :comment_id,     comment: '追溯回复的是哪个评论'
      t.string     :target_type,    comment: '回复的主体'
      t.integer    :target_id,      comment: '回复的主体'
      t.integer    :reply_id,       comment: '追溯回复的是哪条回复'
      t.integer    :reply_user_id,  comment: '回复了哪个用户'
      t.datetime   :deleted_at,     comment: '删除时间'
      t.string     :deleted_reason, comment: '删除的原因'
      t.timestamps
    end
    add_index :replies, [:deleted_at]
    add_index :replies, [:comment_id]
    add_index :replies, [:target_type, :target_id]
  end
end
