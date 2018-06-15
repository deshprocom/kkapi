module V1
  module Weixin
    class NotifyController < ApplicationController
      def create
        @notify_params = Hash.from_xml(request.body.read)['xml']
        ::Weixin::NotifyService.call(find_order, @notify_params, 'from_notified')
        render xml: xml_result
      end

      def find_order
        if params[:order_type] == 'hotel_order'
          HotelOrder.find_by!(order_number: @notify_params['out_trade_no'])
        else
          ::Shop::Order.find_by!(order_number: @notify_params['out_trade_no'])
        end
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

