json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @activities do |activity|
      json.id activity.id
      json.banner activity.preview_image
      json.status activity.activity_status
      json.total_views activity.total_views
    end
  end
end
