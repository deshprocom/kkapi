json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @result do |result|
      json.option_type         result[:option_type]
      json.points              result[:points]
      json.mark                result[:mark]
      json.category            result[:category]
      json.active_at           result[:active_at].to_i
      json.created_at          result[:created_at].to_i
    end
  end
end