json.partial! 'common/basic', api_result: ApiResult.success_result

# data
json.data do
  json.items do
    json.array! @pre_purchase_items.order_items do |item|
      json.number     item.number
      json.title      item.variant.product.title
      json.returnable item.variant.product.returnable
      json.variant do
        json.partial! 'v1/shop/products/variant', variant: item.variant
      end
    end
  end

  json.invalid_items       @pre_purchase_items.invalid_order_items
  json.shipping_price      @pre_purchase_items.shipping_price
  json.total_product_price @pre_purchase_items.total_product_price
  json.total_price         @pre_purchase_items.total_price
end