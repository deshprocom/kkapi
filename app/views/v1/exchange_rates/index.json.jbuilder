json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @rates do |rate|
      json.id            rate.id
      json.rate          rate.rate
      json.rate_type     rate.rate_type
      json.s_currency    rate.s_currency
      json.s_currency_no rate.s_currency_no
      json.t_currency    rate.t_currency
      json.t_currency_no rate.t_currency_no
    end
  end
end