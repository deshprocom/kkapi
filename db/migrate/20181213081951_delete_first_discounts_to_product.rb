class DeleteFirstDiscountsToProduct < ActiveRecord::Migration[5.1]
  def change
    remove_column :shop_products, :first_discounts
  end
end
