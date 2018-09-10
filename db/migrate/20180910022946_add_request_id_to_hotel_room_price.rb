class AddRequestIdToHotelRoomPrice < ActiveRecord::Migration[5.1]
  def change
    add_reference :hotel_room_prices, :sale_room_request, index: true
  end
end
