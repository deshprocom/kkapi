class CreateWithdrawals < ActiveRecord::Migration[5.1]
  def change
    create_table :withdrawals do |t|
      t.references :user
      t.string     :real_name, limit: 50, comment: '真实姓名'
      t.string     :account, comment: '提现账号'
      t.string     :account_type, comment: '提现账号类型 支付宝，银行卡，微信'
      t.string     :account_memo, default: '', comment: '银行卡备忘，如工商银行，农业银行..'
      t.string     :mobile, default: '', comment: '用户手机号'
      t.decimal    :amount, precision: 11, scale: 2, default: 0, comment: '提现金额'
      t.string     :option_status, default: 'pending', comment: 'pending: 申请中，success: 提现成功, failed: 提现失败'
      t.datetime   :option_time, comment: '后台操作时间,提现成功or失败的'
      t.string     :memo, default: '', comment: '备忘'
      t.timestamps
    end

    add_column :user_counters, :freeze_pocket_money, :decimal, precision: 11, scale: 2, default: 0, comment: '冻结中的金额'
  end
end
