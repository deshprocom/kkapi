json.partial! 'common/basic', api_result: ApiResult.success_result

# data
json.data do
  json.items do
    json.array! @products do |product|
      json.id                product.id
      json.category_id       product.category_id
      json.title             product.title
      json.returnable        product.returnable
      json.icon              product.preview_icon
      json.first_discounts   product.first_discounts
      json.price             Shop::FirstDiscountsPrice.call(product, @current_user)
      json.all_stock         product.master.stock
    end
  end
end