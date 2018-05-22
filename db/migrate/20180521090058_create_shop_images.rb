class CreateShopImages < ActiveRecord::Migration[5.1]
  def change
    create_table :shop_images do |t|
      t.references :imageable, polymorphic: true, index: true
      t.string 'image', comment: '图片链接'
      t.bigint  :position, default: 0,  comment: '用于拖拽排序'
      t.timestamps
    end
  end
end
