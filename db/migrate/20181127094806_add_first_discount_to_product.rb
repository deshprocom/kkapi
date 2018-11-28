class AddFirstDiscountToProduct < ActiveRecord::Migration[5.1]
  def change
    add_column :shop_products, :first_discounts, :boolean, comment: '是否首次可1元购买'
  end
end
