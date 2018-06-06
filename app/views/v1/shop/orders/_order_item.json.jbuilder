json.id             item.id
json.product_id     item.product.id
json.title          item.product.title
json.original_price item.original_price
json.price          item.price
json.number         item.number
json.sku_value      item.sku_value
json.return_status  item.recent_return&.return_status
json.returnable     item.returnable
# json.image          item.variant.image&.preview || item.product.preview_icon
json.image          item.variant_image