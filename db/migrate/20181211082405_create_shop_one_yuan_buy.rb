class CreateShopOneYuanBuy < ActiveRecord::Migration[5.1]
  def change
    create_table :shop_one_yuan_buys do |t|
      t.references :product
      t.datetime :begin_time, comment: '活动开始时间'
      t.datetime :end_time, comment: '活动结束时间'
      t.integer :saleable_num,  default: 0, comment: '可卖的总数'
      t.integer :sales_volume,  default: 0, comment: '销售量'
      t.boolean :published, default: false, comment: '是否发布'
      t.boolean :viewable, default: true, comment: '是否在一元购列表中显示'
    end
  end
end
