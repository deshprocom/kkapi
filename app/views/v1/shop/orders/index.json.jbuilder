json.partial! 'common/basic', api_result: ApiResult.success_result

# data
json.data do
  json.items do
    json.array! @orders.includes(order_items: [:product, :recent_return]) do |order|
      json.partial! 'order_info', order: order
      json.order_items do
        json.array! order.order_items do |item|
          json.partial! 'order_item', item: item
        end
      end
    end
  end
end