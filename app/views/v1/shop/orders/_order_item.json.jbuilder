json.id             item.id
json.product_id     item.product.id
json.title          item.product.title
json.original_price item.original_price
json.price          item.price
json.number         item.number
json.sku_value      item.sku_value
json.returnable     item.can_returnable?
json.image          item.variant_image
json.return_status_text item.recent_return&.return_status_text.to_s

merchant = item.product.merchant
if merchant
  json.merchant do
    json.name      merchant.name
    json.telephone merchant.telephone
    json.location  merchant.location
    location_arr = merchant.amap_location.split(',')
    json.longitude location_arr[0]
    json.latitude  location_arr[1]
  end
end