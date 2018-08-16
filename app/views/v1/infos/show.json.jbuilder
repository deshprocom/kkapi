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

    json.type do
      json.slug  @info.info_type.slug
      json.name  @info.info_type.name
    end
  end
end