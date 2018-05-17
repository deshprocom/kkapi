class CreateRecommends < ActiveRecord::Migration[5.1]
  def change
    create_table :recommends do |t|
      t.references :source, polymorphic: true
      t.string  'image'
      t.bigint  'position', default: 0,  comment: '用于拖拽排序'
    end
  end
end
