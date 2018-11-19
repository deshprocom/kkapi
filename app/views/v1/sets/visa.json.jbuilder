json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.description Visa.first&.description.to_s
end