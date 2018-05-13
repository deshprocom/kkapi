class CreateInfo < ActiveRecord::Migration[5.1]
  def change
    create_table :infos do |t|
      t.references :info_type
      t.string  :title
      t.date    :date
      t.string  :image
      t.boolean :stickied,  default: false,   comment: '是否置顶'
      t.boolean :published, default: false,   comment: '是否发布'
      t.text    :description, comment: '图文内容'
      t.timestamps
    end
  end
end
