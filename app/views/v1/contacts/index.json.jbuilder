json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @contacts do |contact|
      json.mobile contact.mobile.to_s
      json.email contact.email.to_s
    end
  end
end