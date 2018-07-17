class AddPositionToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :shop_products, :position, :bigint, default: 0, comment: '用于拖拽排序'
  end
end
