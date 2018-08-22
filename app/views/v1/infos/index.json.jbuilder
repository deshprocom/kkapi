json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @infos do |info|
      json.id      info.id
      json.title   info.title
      json.date    info.date
      json.image   info.preview_image
      json.comments_count info.comments_count
      json.likes_count info.likes_count
      json.total_views info.total_views
    end
  end
end