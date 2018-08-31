class CreateSaleRoomRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :sale_room_requests do |t|
      t.references :user
      t.references :hotel
      t.references :room
      t.string     :room_num, limit: 50, comment: '房号'
      t.string     :card_img, comment: '房卡照片'
      t.date       :checkin_date, comment: '入住时间'
      t.decimal    :price, precision: 15, scale: 2, default: '0.0', comment: '挂售金额'
      t.string     :status, limit: 32, default: 'pending', comment: '申请状态 pending 审核中， passed 已通过， refused 不通过'
      t.boolean    :is_sold, default: false, comment: '是否已卖出'
      t.boolean    :is_withdrawn, default: false, comment: '是否已提现'
    end
  end
end
