module V1::Shop
  class WxNotifyController < ApplicationController
    def create
      notify_params = Hash.from_xml(request.body.read)['xml']
      order = Shop::Order.find_by!(order_number: notify_params['out_trade_no'])
      Shop::WxPaymentResultService.call(order, notify_params, 'from_notified')
      render xml: xml_result
    end

    def result_to_xml(code, msg)
      {
        return_code: code,
        return_msg: msg
      }.to_xml(root: 'xml', dasherize: false)
    end

    def xml_result
      result_to_xml('SUCCESS', 'OK')
    end
  end
end

