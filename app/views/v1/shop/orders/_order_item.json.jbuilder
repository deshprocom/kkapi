json.id             item.id
json.product_id     item.variant&.product&.id
json.title          item.variant&.product&.title
json.original_price item.original_price
json.price          item.price
json.number         item.number
json.sku_value      item.sku_value
json.refund_status     item.refund_status
json.returnable item.returnable
json.image             item.variant.image&.preview || item.variant.product.preview_icon
unless item.refund_status.eql?('none')
  last_refund = item.product_refund_details.last.product_refund
  json.refund_number last_refund.refund_number
  json.refund_type last_refund.product_refund_type.name
end