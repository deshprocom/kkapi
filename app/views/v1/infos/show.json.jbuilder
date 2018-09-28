json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.info do
    json.id            @info.id
    json.title         @info.title
    json.date          @info.date
    json.image         @info.image.url
    json.preview_image @info.preview_image
    json.intro         @info.intro.to_s
    json.description   @info.description
    json.audio_link    @info.audio_link
    json.exist_coupon  @info.coupon_ids.present?
    json.comments_count @info.comments_count
    json.likes_count @info.likes_count
    json.total_views @info.total_views

    json.type do
      json.slug  @info.info_type.slug
      json.name  @info.info_type.name
    end
    json.current_user_liked @current_user&.find_action(:like, target: @info).present?
    json.current_user_favorite @current_user.blank? ? false : @current_user.favorite?(@info)
  end
end