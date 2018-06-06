class CreateShopReturnItem < ActiveRecord::Migration[5.1]
  def change
    create_table :shop_return_items do |t|
      t.references :customer_return
      t.references :order_item
      t.string  :return_type,   limit: 20, default: 'refund', comment: '退回类型： refund: 退货退款, exchange_goods: 换货'
      t.string  :return_status, limit: 20, default: 'pending',  comment: '退回状态 pending: 审核中, refused: 拒绝申请, completed 审核通过完成， cancel_return: 取消退回'
      t.timestamps
    end
  end
end
