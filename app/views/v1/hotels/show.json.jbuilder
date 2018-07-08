json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.hotel do
    json.id           @hotel.id
    json.title        @hotel.title
    json.location     @hotel.location
    json.amap_poiid   @hotel.amap_poiid
    json.logo         @hotel.logo.url
    json.description  @hotel.description
    json.preview_logo @hotel.preview_logo
    json.telephone    @hotel.telephone
    json.region       Hotel::REGIONS_MAP[@hotel.region]
    json.amap_navigation_url @hotel.amap_navigation_url
    json.amap_location       @hotel.amap_location


    json.images do
      json.array! @hotel.images do |image|
        json.id        image.id
        json.image     image.original
      end
    end
  end
end