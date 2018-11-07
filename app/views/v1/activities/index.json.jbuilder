json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @activities do |activity|
      json.id activity.id
      json.title       activity.title.to_s
      json.banner      activity.preview_image
      json.status      activity.activity_status
      json.is_wheel    activity.wheel?
      json.intro       activity.intro.to_s
      json.total_views activity.total_views
    end
  end
end
