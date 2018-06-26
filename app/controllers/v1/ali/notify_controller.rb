module V1
  module Ali
    class NotifyController < ApplicationController
      def shop_order
        Rails.logger.info "Ali::NotifyController request.request_parameters #{request.request_parameters}"
        Rails.logger.info "Ali::NotifyController params #{params}"
        $alipay.verify?(request.request_parameters)
      end
    end
  end
end

