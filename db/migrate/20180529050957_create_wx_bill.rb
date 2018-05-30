class CreateWxBill < ActiveRecord::Migration[5.1]
  def change
    create_table :wx_bills do |t|
      t.references :order, polymorphic: true
      t.string  :transaction_id, limit: 50
      t.string  :wx_result, limit: 2000, comment: '微信支付结果'
      t.string  :source_type, limit: 20, comment: 'from_notified 支付完成后，被微信的主动通知， from_query 服务器主动查询账单'
      t.boolean :pay_success, default: false, comment: '是否支付成功'
      t.index(:transaction_id, unique: true)
      t.timestamps
    end
  end
end
