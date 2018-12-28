class ExtendProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :shop_products, :product_type, :string, default: 'entity', comment: '商品类型 entity 实物， virtual 虚拟产品'
    add_column :shop_products, :visible_discounts_list, :boolean, default: false, comment: '是否显示在折扣列表中'
    add_reference :shop_products, :merchant, index: true
  end
end
