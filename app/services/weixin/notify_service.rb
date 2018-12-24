module Weixin
  class NotifyService
    include Serviceable

    # result 微信支付结果
    # result_type   from_notified 微信支付通知请求， from_query 服务器主动查询账单
    def initialize(order, result, result_type)
      @order = order
      @result = result
      @result_type = result_type
      @wx_bill = WxBill.find_by(transaction_id: @result['transaction_id'])
      Rails.logger.info "WxPaymentResult order_number(#{result['out_trade_no']}): #{result}"
    end

    def call
      # 验证签名是否正确
      raise_error_msg('验证签名失败') unless sign_correct?

      return if result_no_need_processing?

      # 记录的微信账单
      bill_create_or_update

      # 该订单已经支付过，就不需要接下来的验证了
      return if @order.pay_status == 'paid'

      unless result_pay_success?
        raise_error_msg("微信支付失败: #{@result['trade_state_desc'] || @result['err_code_des']}")
      end

      # 检查订单是否存在，订单的金额是否和数据库一致
      return raise_error_msg('订单金额不匹配') unless result_accord_with_order?

      order_to_paid
      got_integral
    end

    private

    def from_query?
      @result_type == 'from_query'
    end

    def from_notified?
      @result_type == 'from_notified'
    end

    # 不需要对微信结果处理
    # 微信账单已存在并且支付成功了
    def result_no_need_processing?
      @wx_bill&.pay_success
    end

    def result_pay_success?
      if from_query?
        # 检查查询的支付结果是否成功
        # SUCCESS—支付成功 REFUND—转入退款 NOTPAY—未支付 CLOSED—已关闭 REVOKED—已撤销（刷卡支付）
        # USERPAYING--用户支付中 PAYERROR--支付失败(其他原因，如银行返回失败)
        # 当手动调用查询订单接口，才有 trade_state
        @result['trade_state'] == 'SUCCESS'
      else
        # 判断微信支付通知请求是否成功
        @result['return_code'] == 'SUCCESS' && @result['result_code'] == 'SUCCESS'
      end
    end

    def transaction_success?
      @result['return_code'].eql?('SUCCESS') && @result['result_code'].eql?('SUCCESS')
    end

    def sign_correct?
      WxPay::Sign.verify?(@result)
    end

    def result_accord_with_order?
      (@order.final_price * 100).to_i == @result['total_fee'].to_i
    end

    def got_integral
      Integral.create_paid_to_integral(user: @order.user,
                                       target: @order,
                                       price: @order.final_price,
                                       option_type: @order.model_name.singular)
    end

    def order_to_paid
      if @order.class.name == 'HotelOrder'
        HotelServices::OrderToPaid.call(@order, 'weixin')
      else
        Shop::OrderToPaidService.call(@order, 'weixin')
      end
    end

    def bill_create_or_update
      if @wx_bill
        @wx_bill.update(bill_params)
      else
        WxBill.create(bill_params)
      end
    end

    def bill_params
      {
        order: @order,
        transaction_id: @result['transaction_id'],
        wx_result: @result,
        source_type: @result_type,
        pay_success: result_pay_success?
      }
    end
  end
end