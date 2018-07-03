module Ali
  class PayService
    include Serviceable
    def initialize(order)
      @order = order
    end

    def call
      raise_error_msg '当前状态不能支付' unless @order.unpaid?

      biz_content = {
        subject: @order.pay_title,
        out_trade_no: @order.order_number,
        total_amount: @order.final_price,
        product_code: 'QUICK_MSECURITY_PAY',
      }
      $alipay.sdk_execute(
        method: 'alipay.trade.app.pay',
        notify_url: notify_url,
        biz_content: biz_content.to_json(ascii_only: true)
      )
    end

    def notify_url
      "#{ENV['HOST_URL']}/v1/ali/notify/#{@order.model_name.singular}"
    end
  end
end
