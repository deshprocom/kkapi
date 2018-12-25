module V1::Shop
  class OrdersController < ApplicationController
    include UserAuthorize
    before_action :login_required
    before_action :set_order, only: [:show, :cancel, :confirm, :wx_pay, :alipay,
                                     :wx_paid_result, :customer_return, :express_tracking]
    SEARCH_STATUS_MAP = {
      unpaid: 'unpaid',
      undelivered: 'paid',
      delivered: 'delivered',
      completed: 'completed'
    }.freeze
    def index
      status = SEARCH_STATUS_MAP[params[:status].to_s.to_sym]
      @orders = @current_user.shop_orders.order(id: :desc)
                             .page(params[:page]).per(params[:page_size])
                             .yield_self { |it| status ? it.where(status: status) : it }
      render 'index'
    end

    def show
      render 'show'
    end

    def new
      shipping_info = params[:shipping_info] || {}
      province = shipping_info[:address] && shipping_info[:address][:province]
      @pre_purchase_items = Shop::PrePurchaseItems.new(@current_user, params[:variants], province)
      if @pre_purchase_items.check_result != 'ok'
        return render_api_error(@pre_purchase_items.check_result)
      end
      render 'new'
    end

    def create
      result = ::Shop::CreateOrderService.call(@current_user, params)
      render 'create', locals: result
    end

    def cancel
      return render_api_error('该订单已支付，不允许取消订单') unless @order.status == 'unpaid'
      @order.cancel_order(params[:reason])
      render_api_success
    end

    def confirm
      return render_api_error('当前状态不允许确认收货') unless @order.status == 'delivered'
      @order.complete!
      render_api_success
    end

    # params
    # {
    #   "return_type":"refund",
    #   "return_items":[1， 2],
    #   "memo":"商品坏了"
    # }
    def customer_return
      Shop::CustomerReturnService.call(@order, params)
      render_api_success
    end

    def wx_pay
      optional! :trade_source, values: %w[app miniprogram], default: 'app'
      # 获取用户真实ip
      #  需要在nginx中设置 proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      client_ip = request.env['HTTP_X_FORWARDED_FOR']
      @prepay_result = ::Weixin::PayService.call(@order, client_ip, params[:trade_source])
      if params[:trade_source] == 'app'
        render 'wx_pay'
      else
        render 'miniprogram_pay_result'
      end
    end

    def alipay
      @payment_params = ::Ali::PayService.call(@order)
    end

    def wx_paid_result
      optional! :trade_source, values: %w[app miniprogram], default: 'app'
      appid = @trade_source == 'app' ? ENV['WX_APP_ID'] : ENV['MINIPROGRAM_APP_ID']
      result = WxPay::Service.order_query(out_trade_no: @order.order_number, appid: appid)
      ::Weixin::NotifyService.call(@order, result[:raw]['xml'], 'from_query')
      render_api_success
    end

    def express_tracking
      return render_api_error('该订单未发货') unless @order.delivered?

      @shipment = @order.shipment
      @tracking = Kuaidiniao::Service.get_trace(@shipment.express.code, @shipment.express_number)
    end

    private

    def set_order
      @order = @current_user.shop_orders.find_by!(order_number: params[:id])
    end
  end
end