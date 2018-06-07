module Shop
  class CustomerReturnService
    include Serviceable

    # params
    # {
    #   "return_type":"refund",
    #   "return_items":[1， 2],
    #   "memo":"商品坏了"
    # }
    def initialize(order, params)
      @order = order
      @params = params
      @return_items = params[:return_items].map { |id| order.order_items.find(id) }
      @return_type = params[:return_type] == 'refund' ? 'refund' : 'exchange_goods'
    end

    def call
      raise_error_msg '已有待处理的售后申请' if exist_pending_return?
      raise_error_msg '订单未付款，不允许申请退回' if @order.unpaid?
      raise_error_msg '超过了发货时间30天，不允许申请退回' if @order.delivered_over_30_days?
      raise_error_msg '有已退款的商品, 不允许重复申请退回' if items_refunded?

      customer_return = @order.customer_returns.create(return_type: @return_type,
                                                       return_status: 'pending',
                                                       user_id: @order.user_id,
                                                       refund_price: refund_price,
                                                       memo: @params[:memo])

      @return_items.each do |item|
        customer_return.return_items.create(order_item: item,
                                            return_type: @return_type,
                                            return_status: 'pending')
      end
    end

    def refund_price
      return 0.0 if @return_type == 'exchange_goods'

      refund_product_price + refund_shipping_price
    end

    # 申请换货，退款金额为0
    def refund_product_price
      @return_items.map { |item| item.number * item.price }.sum
    end

    def refund_shipping_price
      # 未发货，并且退款所有商品
      return @order.shipping_price if !@order.delivered? && return_all_items?

      0.0
    end

    def return_all_items?
      @return_items.size == @order.order_items.size
    end

    def exist_pending_return?
      @order.customer_returns.pending.exists?
    end

    def items_refunded?
      @return_items.each { |item| return true if item.refunded? }

      false
    end
  end
end
