class CreateIntegrals < ActiveRecord::Migration[5.1]
  def change
    # 积分明细表
    create_table :integrals do |t|
      t.references :user
      t.string     :target_type
      t.integer    :target_id
      t.string     :option_type, default: '', comment: 'roll_in->转入, roll_out->转出'
      t.integer    :points,      default: 0,  comment: '积分数量'
      t.string     :mark,        default: '', comment: '备注'
      t.datetime   :received_at,              comment: '领取的时间'
      t.timestamps
    end
    add_index :integrals, [:option_type]
    add_index :integrals, [:target_type, :target_id]

    # 积分规则表
    create_table :integral_rules do |t|
      t.string  :option_type_alias, default: '',   comment: '操作类型别名'
      t.string  :option_type,       default: '',   comment: '操作类型'
      t.integer :limit_times,       default: 0,    comment: '次数上限'
      t.integer :points,            default: 0,    comment: '增加积分'
      t.boolean :opened,            default: true, comment: '开关'
      t.timestamps
    end
    add_index :integral_rules, [:option_type]
  end
end
