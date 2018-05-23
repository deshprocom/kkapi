class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
      t.references :user
      t.string   :target_type,                     comment: '举报的对象'
      t.integer  :target_id,                       comment: '举报的对象ID'
      t.string   :body,        default: '',        comment: '举报的内容'
      t.boolean  :ignored,     default: false,     comment: '是否忽略'
      t.timestamps
    end

    add_column :topics, :reports_count, :integer, default: 0, comment: '举报数'
  end
end
