module V1
  module Weixin
    class NotifyController < ApplicationController
      before_action :set_notify_params

      def shop_order
        order = ::Shop::Order.find_by!(order_number: @notify_params['out_trade_no'])
        ::Weixin::NotifyService.call(order, @notify_params, 'from_notified')
        render xml: xml_result
      end

      def hotel_order
        order = HotelOrder.find_by!(order_number: @notify_params['out_trade_no'])
        ::Weixin::NotifyService.call(order, @notify_params, 'from_notified')
        render xml: xml_result
      end

      def set_notify_params
        @notify_params = Hash.from_xml(request.body.read)['xml']
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
end

