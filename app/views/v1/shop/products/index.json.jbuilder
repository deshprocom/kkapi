json.partial! 'common/basic', api_result: ApiResult.success_result

# data
json.data do
  json.items do
    json.array! @products do |product|
      json.id                product.id
      json.category_id       product.category_id
      json.title             product.title
      json.intro             product.intro
      json.returnable        product.returnable
      json.icon              product.preview_icon
      json.first_discounts   Shop::FirstDiscountsPrice.able_discounts?(product, @current_user)
      json.price             Shop::FirstDiscountsPrice.call(product, @current_user)
      json.original_price    product.master.original_price
      json.all_stock         product.master.stock
      json.sales_volume      product.counter&.sales_volume
    end
  end
end