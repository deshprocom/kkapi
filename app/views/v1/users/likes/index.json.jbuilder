json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @likes do |item|
      model_name = item.class.to_s.tableize.singularize
      json.target_type model_name
      json.partial! 'v1/briefs/base', model_type: model_name, target: item
    end
  end
  json.likes_count @likes.count
end