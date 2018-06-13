class CreateHotelOrder < ActiveRecord::Migration[5.1]
  def change
    create_table :hotel_orders do |t|
      t.references :user
      t.references :hotel_room
      t.string  :order_number, limit: 32, null: false, comment: '订单编号', index: true
      t.string  :status, limit: 32, default: 'unpaid', comment: '订单状态'
      t.string  :pay_status, limit: 32, default: 'unpaid', comment: '支付状态'
      t.integer :room_num, default: 1, comment: '房间数量'
      t.string  :telephone, limit: 32, comment: '联系电话'
      t.string  :room_items, limit: 1024, comment: '用json存预定房间的明细'
      t.decimal :total_price, precision: 15, scale: 2, default: '0.0', comment: '总金额'
      t.decimal :final_price, precision: 15, scale: 2, default: '0.0', comment: '最终支付金额'
      t.decimal :discount_amount, precision: 15, scale: 2, default: '0.0', comment: '已优惠减免的金额'
      t.decimal :refund_price, precision: 15, scale: 2, default: '0.0'
      t.date    :checkin_date, comment: '入住时间'
      t.date    :checkout_date, comment: '离店时间'
      t.timestamps
    end

    create_table :checkin_infos do |t|
      t.references :hotel_order
      t.string :first_name, comment: '名'
      t.string :last_name, comment: '姓'
    end
  end
end
