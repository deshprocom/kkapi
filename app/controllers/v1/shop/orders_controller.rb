module V1::Shop
  class OrdersController < ApplicationController
    include UserAuthorize
    before_action :login_required
    before_action :set_order, only: [:show, :cancel, :confirm]
    SEARCH_STATUS_MAP = {
      unpaid: 'unpaid',
      undelivered: 'paid',
      delivered: 'delivered',
      completed: 'completed'
    }
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
      @pre_purchase_items = Shop::PrePurchaseItems.new(params[:variants], province)
      if @pre_purchase_items.check_result != 'ok'
        return render_api_error(@pre_purchase_items.check_result)
      end
      render 'new'
    end

    def create
      result = Shop::CreateOrderService.call(@current_user, params)
      render 'create', locals: result
    end

    def cancel
      return render_api_error('该订单已支付，不允许取消订单') unless @order.status == 'unpaid'
      @order.cancel_order(params[:reason])
      render_api_success
    end

    def confirm
      return render_api_error('当前状态不允许确认收货') unless @order.status == 'delivered'
      @order.completed!
      render_api_success
    end

    private

    def set_order
      @order = @current_user.shop_orders.find_by!(order_number: params[:id])
    end
  end
end