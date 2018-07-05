class CreatePocketMoneys < ActiveRecord::Migration[5.1]
  def change
    create_table :pocket_moneys do |t|
      t.references :user
      t.string     :option_type, default: 'invite', comment: '操作类型，invite邀请注册, ...'
      t.string     :target_type
      t.integer    :target_id
      t.string     :second_target_type
      t.integer    :second_target_id
      t.decimal    :amount, precision: 11, scale: 2, default: 0, comment: '零钱金额'
      t.timestamps
    end

    add_index :pocket_moneys, [:target_type, :target_id]
    add_index :pocket_moneys, [:second_target_type, :second_target_id]

    add_column :user_counters, :total_pocket_money, :decimal, precision: 11, scale: 2, default: 0, comment: '零钱总额'

    create_table :invite_awards do |t|
      t.boolean :published, default: true, comment: '是否开启奖励，默认开启'
      t.decimal :direct_award,   precision: 11, scale: 2, default: 1.0, comment: '直接推广奖励'
      t.decimal :indirect_award, precision: 11, scale: 2, default: 0.5, comment: '间接推广奖励'
      t.timestamps
    end
  end
end
