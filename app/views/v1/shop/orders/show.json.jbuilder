json.partial! 'common/basic', api_result: ApiResult.success_result

# data
json.data do
  json.partial! 'order_info', order: @order
  json.order_items do
    json.array! @order.order_items do |item|
      json.partial! 'order_item', item: item
    end
  end
  json.address do
    json.partial! 'address', order: @order
  end
  if @order.delivered?
    json.shipments do
      json.partial! 'shipment', order: @order
    end
  end
end