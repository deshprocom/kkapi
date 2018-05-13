json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.info do
    json.id            @info.id
    json.title         @info.title
    json.date          @info.date
    json.image         @info.image.url
    json.preview_image @info.preview_image
    json.description   @info.description

    json.type do
      json.slug  @info.info_type.slug
      json.name  @info.info_type.name
    end
  end
end