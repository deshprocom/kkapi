class AddTraderTypeToTraders < ActiveRecord::Migration[5.1]
  def change
    add_column :exchange_traders, :trader_type, :string,
               default: 'ex_rate', limit: 32,
               comment: 'ex_rate 汇率达人, integral 积分达人, dating 交友达人'
    add_column :exchange_traders, :score, :integer, default: 0, comment: '分数'
  end
end
