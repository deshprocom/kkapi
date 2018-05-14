json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.image_url            @image.image_url
  json.preview_image        @image.preview_image
  json.created_at           @image.created_at.to_i
end