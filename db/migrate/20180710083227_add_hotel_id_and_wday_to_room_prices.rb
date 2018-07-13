class AddHotelIdAndWdayToRoomPrices < ActiveRecord::Migration[5.1]
  def up
    add_reference :hotel_room_prices, :hotel, index: true
    add_column :hotel_room_prices, :wday, :string, limit: 5, comment: 'sun mon tue wed thu fri sat'
    HotelRoomPrice.find_each do |price|
      price.hotel_id = price.hotel_room&.hotel_id
      price.save
    end
  end

  def down
    remove_reference :hotel_room_prices, :hotel, index: true
    remove_column :hotel_room_prices, :wday
  end
end
