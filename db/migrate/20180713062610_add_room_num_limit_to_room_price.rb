class AddRoomNumLimitToRoomPrice < ActiveRecord::Migration[5.1]
  def change
    add_column :hotel_room_prices, :room_num_limit, :integer, default: 50, comment: '每天售卖房间的数量限制'
    add_column :hotel_room_prices, :room_sales, :integer, default: 0, comment: '每天卖出的数量'
  end
end
