class ChangeOrderItem < ActiveRecord::Migration[5.1]
  def up
    remove_column :shop_order_items, :refund_status
    add_column :shop_order_items, :refunded, :boolean, default: false, comment: '是否已退款'
  end

  def down
    add_column :shop_order_items, :refund_status, :string
    remove_column :shop_order_items, :refunded
  end
end
