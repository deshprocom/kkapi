class CreateExchangeTrader < ActiveRecord::Migration[5.1]
  def change
    create_table :exchange_traders do |t|
      t.references :user
      t.bigint :position, default: 0,  comment: '用于排序'
      t.string :memo
    end
  end
end
