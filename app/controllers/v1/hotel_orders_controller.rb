module V1
  class HotelOrdersController < ApplicationController
    include UserAuthorize
    before_action :login_required
    before_action :set_order, only: [:show, :cancel, :destroy, :wx_pay,
                                     :alipay, :refund, :wx_paid_result]

    # params
    # {
    #   "checkin_date": "2018-06-11",
    #   "checkout_date": "2018-06-13",
    #   "hotel_room_id": 33,
    #   "room_num": 1
    # }
    def new
      order_service = HotelServices::CreateOrder.new(@current_user, order_params, params[:coupon_id])
      order_service.collect_room_items
      order_service.check_room_saleable!
      order_service.use_coupon!
      @order = order_service.order
      @room  = order_service.room
      @min_saleable_num = order_service.min_saleable_num
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
      @order = HotelServices::CreateOrder.call(@current_user, order_params, params[:coupon_id])
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
      @order.coupon && @order.coupon.update(coupon_status: 'refund', refund_time: Time.now)
      render_api_success
    end

    def destroy
      return render_api_error('该订单不允许删除') unless @order.status.in? %w[confirmed canceled]
      @order.deleted!
      render_api_success
    end

    def wx_pay
      check_order_payable
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

    def check_order_payable
      @order.room_items.each do |item|
        room_price = HotelRoomPrice.find_by(id: item['price_id'])
        next if room_price&.saleable_num.to_i > 0

        @order.canceled!
        raise_error '该订单已失效，请重新下单', false
      end
    end

    def refund
      HotelServices::RefundOrder.call(@order, @current_user, params[:memo])
      render_api_success
    end

    def alipay
      check_order_payable
      @payment_params = ::Ali::PayService.call(@order)
    end

    private

    def set_order
      @order = @current_user.hotel_orders.find_by!(order_number: params[:id])
    end

    def order_params
      params.permit(:hotel_room_id, :checkin_date, :checkout_date, :room_price_id,
                    :room_num, :telephone, checkin_infos: [:last_name, :first_name])
    end
  end
end
