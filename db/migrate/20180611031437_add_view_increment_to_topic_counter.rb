class AddViewIncrementToTopicCounter < ActiveRecord::Migration[5.1]
  def change
    add_column :topic_counters, :view_increment, :integer, default: 0, comment: '浏览量增量'

    create_table :view_toggles do |t|
      t.string   :target_type, comment: '节点对象'
      t.integer  :target_id, comment: '节点对象'
      t.boolean  :toggle_status, default: false, comment: '是否打开, 默认关闭'
      t.boolean  :hot, default: false, comment: '是否是热增长'
      t.datetime :begin_time
      t.datetime :last_time
      t.timestamps
    end
    add_index :view_toggles, [:target_type, :target_id]

    create_table :view_rules do |t|
      t.integer :day, default: 0, comment: '第几天'
      t.integer :interval, default: 0, comment: '时间间隔，单位分钟'
      t.integer :min_increase, default: 0, comment: '最小增长量'
      t.integer :max_increase, default: 0, comment: '最大增长量'
      t.boolean :hot, default: false, comment: '是否是热增长'
      t.timestamps
    end
  end
end
