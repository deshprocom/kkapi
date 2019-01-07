module V1::Merchant
  class OrderVerificationsController < MerchantApplicationController

    def create
      @order = Shop::Order.find_by!(order_number: params[:order_number])
      return render_api_error('当前状态不允许核销') unless @order.status == 'paid'

      Rails.logger.info "OrderVerificationsController: order_number #{@order.order_number}, user: #{current_user.id}"
      @order.update(status: 'completed', completed_at: Time.zone.now)
      render_api_success
    end
  end
end
