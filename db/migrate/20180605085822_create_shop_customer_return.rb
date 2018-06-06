class CreateShopCustomerReturn< ActiveRecord::Migration[5.1]
  def change
    create_table :shop_customer_returns do |t|
      t.references :order
      t.references :user
      t.string  :out_refund_no, limit: 64, null: false, comment: '退款编号'
      t.decimal :refund_price, precision: 15, scale: 2, default: 0.0, comment: '申请退款金额'
      t.string  :return_type,   limit: 20, default: 'refund', comment: '退回类型： refund: 退货退款, exchange_goods: 换货'
      t.string  :return_status, limit: 20, default: 'pending',  comment: '退回状态 pending: 审核中, refused: 拒绝申请, completed 审核通过完成， cancel_return: 取消退回'
      t.string  :memo, comment: '用户备注'
      t.string  :admin_memo, comment: '审核备注'
      t.timestamps
    end
  end
end
