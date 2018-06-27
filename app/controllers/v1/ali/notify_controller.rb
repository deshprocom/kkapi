module V1
  module Ali
    class NotifyController < ApplicationController
      before_action :set_result

      def shop_order
        order = ::Shop::Order.find_by!(order_number: @pay_result['out_trade_no'])
        render_result ::Ali::NotifyService.call(order, @pay_result)
      end

      def hotel_order
        order = HotelOrder.find_by!(order_number: @pay_result['out_trade_no'])
        render_result ::Ali::NotifyService.call(order, @pay_result)
      end

      def render_result(result)
        if result == 'fail'
          render plain: 'fail'
        else
          render plain: 'success'
        end
      end

      def set_result
        @pay_result = request.request_parameters
      end
    end
  end
end

