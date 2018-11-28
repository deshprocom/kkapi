json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.homepage_images do
    json.hotel_image @page_images[:hotel_image]
    json.cate_image @page_images[:cate_image]
    json.rate_image @page_images[:rate_image]
    json.recreation_image @page_images[:recreation_image]
  end

  json.visa_description @visa&.description.to_s

  json.hotel_contact ENV['HOTEL_APP_MOBILE']
end