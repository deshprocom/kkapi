json.partial! 'common/basic', api_result: ApiResult.success_result

# data
json.data do
  json.room do
    json.id     @room.id
    json.title  @room.title
    json.tags   @room.tags
    json.notes  @room.notes
    json.images @room.images.map(&:original)
  end

  json.order do
    json.total_price @order.total_price_from_items

    json.room_num    @order.room_num
    json.room_items do
      json.array! @order.room_items do |item|
        json.date  item['date']
        json.price item['price']
      end
    end
  end
end
