json.partial! 'common/basic', api_result: ApiResult.success_result

# data
json.data do
  json.categories do
    json.partial! 'v1/shop/categories/categories', categories: @categories
  end
end