module HotelServices
  class RefundOrder
    include Serviceable

    def initialize(order, user, memo)
      @order = order
      @user = user
      @memo = memo
    end

    def call
      raise_error_msg '该订单未付款' if @order.unpaid?

      raise_error_msg '该订单已退款' if @order.refunded?

      raise_error_msg '已超过入住时间，不允许退款' if over_checkin_date?

      raise_error_msg '存在待审核的退款申请' if exist_pending_refund?
      HotelRefund.create(hotel_order: @order,
                         user: @user,
                         refund_price: @order.final_price,
                         refund_status: 'pending',
                         out_refund_no: SecureRandom.hex(16),
                         memo: @memo )
    end

    def exist_pending_refund?
      @order.hotel_refunds.pending.exists?
    end

    def over_checkin_date?
      Time.now > @order.checkin_date
    end
  end
end
