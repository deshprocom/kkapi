json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @infos.includes(:info_type) do |info|
      json.id      info.id
      json.title   info.title
      json.date    info.date
      json.image   info.preview_image
      json.comments_count info.comments_count
      json.likes_count info.likes_count
      json.favorites_count info.favorites_count
      json.total_views info.total_views

      json.info_type do
        json.name info.info_type.name
        json.slug info.info_type.slug
      end
    end
  end
end