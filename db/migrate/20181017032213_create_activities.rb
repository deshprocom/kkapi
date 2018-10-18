class CreateActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :activities do |t|
      t.string     :title, default: '', comment: '活动标题'
      t.text       :description, comment: "图文内容"
      t.string     :banner, comment: '横图'
      t.datetime   :begin_time, comment: '活动开始时间'
      t.datetime   :end_time, comment: '活动结束时间'
      t.boolean    :published, default: false, comment: '是否发布'
      t.boolean    :canceled,  default: false, comment: '是否取消'
      t.integer    :likes_count, default: 0, comment: '喜欢数'
      t.integer    :page_views, default: 0, comment: '浏览次数'
      t.integer    :view_increment, default: 0, comment: '浏览量增量'
      t.timestamps
    end
  end
end
