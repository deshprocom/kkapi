class CreateShopOrder < ActiveRecord::Migration[5.1]
  def change
    create_table :shop_orders do |t|
      t.references :user
      t.string   :order_number, limit: 32, null: false, comment: '商品订单编号', index: true
      t.string   :status,     default: 'unpaid', comment: '订单状态'
      t.string   :pay_status, default: 'unpaid', comment: '支付状态'
      t.decimal  :shipping_price,      precision: 15, scale: 2, default: '0.0', comment: '总运金额'
      t.decimal  :total_product_price, precision: 15, scale: 2, default: '0.0', comment: '总商品金额'
      t.decimal  :total_price,         precision: 15, scale: 2, default: '0.0', comment: '总金额'
      t.decimal  :final_price,         precision: 15, scale: 2, default: '0.0', comment: '最终支付金额'
      t.datetime :cancelled_at,  comment: '取消时间'
      t.string   :cancel_reason, default: '', comment: '取消原因'
      t.datetime :deleted_at,  comment: '删除时间'
      t.datetime :delivered_at,  comment: '发货时间'
      t.datetime :completed_at,  comment: '确认收货时间'
      t.string   :memo,            comment: '用户备注'
      t.decimal  :refund_price,                   precision: 15, scale: 2, default: '0.0'
      t.timestamps
    end

    create_table :shop_order_items do |t|
      t.references :order
      t.references :variant
      t.references :product
      t.decimal  :original_price, precision: 15, scale: 2, default: '0.0',  null: false
      t.decimal  :price,          precision: 15, scale: 2, default: '0.0',  null: false
      t.integer  :number, null: false, comment: '购买数量'
      t.string   :sku_value, default: '', comment: '商品属性组合'
      t.boolean  :returnable, default: false,  comment: '是否支持退货'
      t.string   :refund_status, default: 'none', comment: 'none 没有退款申请， pending 退款申请中, refused 拒绝退款， completed 完成退款'
      t.timestamps
    end
  end
end
