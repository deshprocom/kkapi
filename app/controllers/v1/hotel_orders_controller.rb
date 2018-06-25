module V1
  class HotelOrdersController < ApplicationController
    include UserAuthorize
    before_action :login_required
    before_action :set_order, only: [:show, :cancel, :destroy, :wx_pay,
                                     :refund, :wx_paid_result]

    # params
    # {
    #   "checkin_date": "2018-06-11",
    #   "checkout_date": "2018-06-13",
    #   "hotel_room_id": 33,
    #   "room_num": 1
    # }
    def new
      order_service = HotelServices::CreateOrder.new(@current_user, order_params)
      order_service.collect_room_items
      @order = order_service.order
      @room  = order_service.room
    end

    # params
    # {
    #   "checkin_date":"2018-06-11",
    #   "checkout_date":"2018-06-13",
    #   "hotel_room_id":33,
    #   "room_num":2,
    #   "telephone":"13428722299",
    #   "checkin_infos":[
    #      {"last_name":"杨", "first_name":"先生"},
    #      {"last_name":"黄", "first_name":"先生"}
    #    ]
    # }
    def create
      @order = HotelServices::CreateOrder.call(@current_user, order_params)
    end

    SEARCH_STATUS_MAP = {
      unpaid: 'unpaid',
      paid: 'paid',
      confirmed: 'confirmed'
    }.freeze
    def index
      status = SEARCH_STATUS_MAP[params[:status].to_s.to_sym]
      @orders = @current_user
                  .hotel_orders
                  .yield_self { |it| status ? it.where(status: status) : it }
                  .includes(:recent_refund, hotel_room: [:hotel])
                  .page(params[:page]).per(params[:page_size])
    end

    def show; end

    def cancel
      return render_api_error('该订单不允许取消') unless @order.unpaid?
      @order.canceled!
      render_api_success
    end

    def destroy
      return render_api_error('该订单不允许删除') unless @order.status.in? %w[confirmed canceled]
      @order.deleted!
      render_api_success
    end

    def wx_pay
      # 获取用户真实ip
      #  需要在nginx中设置 proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      client_ip = request.env['HTTP_X_FORWARDED_FOR']
      @prepay_result = ::Weixin::PayService.call(@order, client_ip)
    end

    def wx_paid_result
      result = WxPay::Service.order_query(out_trade_no: @order.order_number)
      ::Weixin::NotifyService.call(@order, result[:raw]['xml'], 'from_query')
      render_api_success
    end

    def refund
      HotelServices::RefundOrder.call(@order, @current_user, params[:memo])
      render_api_success
    end

    private

    def set_order
      @order = @current_user.hotel_orders.find_by!(order_number: params[:id])
    end

    def order_params
      params.permit(:hotel_room_id, :checkin_date, :checkout_date,
                    :room_num, :telephone, checkin_infos: [:last_name, :first_name])
    end
  end
end
