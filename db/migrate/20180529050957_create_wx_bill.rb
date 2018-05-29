class CreateWxBill < ActiveRecord::Migration[5.1]
  def change
    create_table :wx_bills do |t|
      t.references :order, polymorphic: true
      t.string :transaction_id, limit: 50
      t.string :wx_result, limit: 1000, comment: '微信支付结果'
      t.index(:transaction_id, unique: true)
    end
  end
end
