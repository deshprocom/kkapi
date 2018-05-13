class CreateExchangeRate < ActiveRecord::Migration[5.1]
  def change
    create_table :exchange_rates do |t|
      t.string  :s_currency, comment: '源币种'
      t.string  :s_currency_no, comment: '源币种编号'
      t.string  :t_currency, comment: '目标币种'
      t.string  :t_currency_no, comment: '目标币种编号'
      t.string  :rate_type,  comment: '汇率类型， real_time 实时汇率， local 本地汇率'
      t.decimal :rate, precision: 10, scale: 4, default: '0.0000', comment: ' 汇率结果(保留6位小数四舍五入)'
      t.timestamps
    end
  end
end
