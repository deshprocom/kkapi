json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.cny_to_hkd_rate do
    json.rate          @cny_to_hkd_rate.rate
    json.s_currency_no @cny_to_hkd_rate.s_currency_no
    json.t_currency_no @cny_to_hkd_rate.t_currency_no
  end

  json.cny_to_mop_rate do
    json.rate          @cny_to_mop_rate.rate
    json.s_currency_no @cny_to_mop_rate.s_currency_no
    json.t_currency_no @cny_to_mop_rate.t_currency_no
  end
end