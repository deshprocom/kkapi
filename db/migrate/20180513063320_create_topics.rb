class CreateTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :topics do |t|
      t.references :user
      t.string   :title,       default: '',        comment: '话题的标题'
      t.string   :cover_link,  default: '',        comment: '话题的封面图片'
      t.string   :body,        default: '',        comment: '话题的内容'
      t.string   :body_type,   default: '',        comment: '话题的类型'
      t.string   :images,      default: '',        comment: '图片集合'
      t.string   :status,      default: 'pending', comment: '审核中-pending, 审核通过-passed, 审核失败-failed'
      t.boolean  :stickied,    default: false,     comment: '是否置顶'
      t.boolean  :excellent,   default: false,     comment: '是否加精华'
      t.datetime :deleted_at,                      comment: '删除时间'
      t.string   :deleted_reason,                  comment: '删除的原因'
      t.float    :lat,                             comment: '经度'
      t.float    :lng,                             comment: '纬度'
      t.string   :address_title,                   comment: '地址短标题'
      t.string   :address,                         comment: '地址详细'
      t.integer  :likes_count, default: 0,         comment: '点赞数'
      t.timestamps
    end
    add_index :topics, :deleted_at
    add_index :topics, [:body_type, :status]
    add_index :topics, [:body_type, :stickied]
    add_index :topics, [:body_type, :excellent]

    create_table :topic_counters do |t|
      t.references :topic
      t.integer :page_views, default: 0, comment: '用户浏览次数'
      t.integer :comments,   default: 0, comment: '用户评论数'
      t.timestamps
    end

    create_table :topic_notifications do |t|
      t.references :user
      t.integer :from_user_id, comment: '来源的用户'
      t.string :notify_type, comment: '消息的类型:评论，回复，点赞...'
      t.string :source_type, comment: '产生消息的出处'
      t.integer :source_id,  comment: '产生消息的出处'
      t.datetime :read_at
      t.timestamps
    end
    add_index :topic_notifications, [:read_at]

    create_table :topic_images do |t|
      t.string :image
      t.timestamps
    end
  end
end
