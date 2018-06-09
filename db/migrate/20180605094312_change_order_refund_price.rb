class ChangeOrderRefundPrice < ActiveRecord::Migration[5.1]
  def up
    remove_column :shop_orders, :refund_price
    add_column :shop_orders, :refunded_price, :decimal,
               precision: 15, scale: 2, default: 0.0, comment: '已退款金额'
  end

  def down
    add_column :shop_orders, :refund_price, :decimal
    remove_column :shop_orders, :refunded_price
  end
end
