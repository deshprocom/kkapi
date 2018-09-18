class AddCounterToMerchantUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :merchant_users, :revenue, :decimal,
               precision: 15,
               scale: 2,
               default: 0.0,
               comment: '总收益'
    add_column :merchant_users, :withdrawal_amount, :decimal,
               precision: 15,
               scale: 2,
               default: 0.0,
               comment: '提现总计'
  end
end
