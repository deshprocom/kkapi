class AddShippingToProduct < ActiveRecord::Migration[5.1]
  def change
    add_reference :shop_products, :shipping, comment: '属于一个运费模板'
  end
end
