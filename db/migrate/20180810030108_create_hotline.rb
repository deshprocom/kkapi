class CreateHotline < ActiveRecord::Migration[5.1]
  def change
    create_table :hotlines do |t|
      t.string :line_type, limit: 32, comment: '热线类型 fast_food 快餐， public_service 公共服务'
      t.string :title
      t.string :telephone
      t.bigint :position, default: 0,  comment: '用于排序'
    end
  end
end
