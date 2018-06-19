class CreateHotelRoomPrices < ActiveRecord::Migration[5.1]
  def change
    create_table :hotel_room_prices do |t|
      t.references :hotel_room
      t.boolean    :is_master, default: false, comment: 'true 为房间的默认价格'
      t.date       :date, comment: '指定日期', index: true
      t.decimal    :price, precision: 11, scale: 2, default: 0, comment: '指定价格'
    end
  end
end
