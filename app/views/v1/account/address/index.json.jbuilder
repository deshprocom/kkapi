# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result

# data
json.data do
  json.items do
    json.array! @addresses do |ads|
      json.partial! 'base', address: ads
    end
  end
end