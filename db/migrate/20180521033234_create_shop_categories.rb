class CreateShopCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :shop_categories do |t|
      t.string :name
      t.string :image
      t.integer :parent_id, null: true, index: true
      t.integer :lft, null: false, index: true
      t.integer :rgt, null: false, index: true
      t.integer :depth, null: false, default: 0
      t.integer :children_count, null: false, default: 0, comment: '该分类下所有子分类的统计'
      t.integer :products_count, null: false, default: 0, comment: '该分类下所有产品的统计'
      t.bigint  :position, default: 0,  comment: '用于拖拽排序'
      t.timestamps
    end
  end
end
