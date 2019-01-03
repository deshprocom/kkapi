json.partial! 'common/basic', api_result: ApiResult.success_result

# data
json.data do
  json.items do
    json.array! @buys do |buy|
      product = buy.product
      json.id             buy.id
      json.saleable_num   buy.saleable_num
      json.sales_volume   buy.sales_volume
      json.begin_time     buy.begin_time.to_i
      json.end_time       buy.end_time.to_i
      json.one_yuan_buy_status buy.buy_status
      json.product_id     product.id
      json.category_id    product.category_id
      json.title          product.title
      json.returnable     product.returnable
      json.original_price product.master.original_price
      json.price          1.to_d
      json.icon           product.preview_icon
    end
  end
end