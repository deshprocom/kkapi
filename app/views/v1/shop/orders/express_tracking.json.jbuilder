json.partial! 'common/basic', api_result: ApiResult.success_result

# data
json.data do
  json.success @tracking['Success']
  json.state @tracking['State']
  json.order_number @tracking['OrderCode'].to_s
  json.traces do
    json.array! @tracking['Traces'] do |item|
      json.accept_station item['AcceptStation']
      json.accept_time item['AcceptTime']
    end
  end
  json.reason @tracking['Reason'].to_s

  json.shipping_number @tracking['LogisticCode']
  json.express_code    @tracking['ShipperCode']
  json.express_name    @shipment.express.name
end
