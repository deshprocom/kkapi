module Shop
  class WxNotifyService
    include Serviceable

    def initialize(result)
      Rails.logger.info "wx notify: #{result}"
      @result  = result
      @order = Order.find_by!(order_number: result['out_trade_no'])
    end

    def call
      # 检查支付是否成功
      # SUCCESS—支付成功 REFUND—转入退款 NOTPAY—未支付 CLOSED—已关闭 REVOKED—已撤销（刷卡支付）
      # USERPAYING--用户支付中 PAYERROR--支付失败(其他原因，如银行返回失败)
      # 当手动调用查询订单接口，才有 trade_state
      if @result.key?('trade_state') && @result['trade_state'] != 'SUCCESS'
        # trade_state_desc: 对当前查询订单状态的描述和下一步操作的指引
        raise_error_msg(@result['trade_state_desc'] || @result['err_code_des'])
      end

      # 验证签名是否正确
      raise_error_msg('验证签名失败') unless sign_correct?

      return ApiResult.success_result if repeated_notify?

      # 判断请求是否成功
      return error_result('微信交易失败') unless transaction_success?

      # 检查订单是否存在，订单的金额是否和数据库一致
      return error_result('订单金额不匹配') unless result_accord_with_order?

      order_to_paid
      # 记录的微信账单
      ProductWxBill.create(bill_params)
      ApiResult.success_result
    end

    private

    def repeated_notify?
      wx_bill_exists? && @order.paid?
    end

    def wx_bill_exists?
      ProductWxBill.exists?(transaction_id: @result['transaction_id'])
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

    def order_to_paid
      @order.update(status: 'paid', pay_status: 'paid') if @order.unpaid?
    end

    def error_result(msg)
      ApiResult.error_result(INVALID_ORDER, msg)
    end

    def bill_params
      { bank_type: @result['bank_type'],
        cash_fee: @result['cash_fee'],
        fee_type: @result['fee_type'],
        is_subscribe: @result['is_subscribe'],
        mch_id: @result['mch_id'],
        open_id: @result['openid'],
        product_order: @order,
        result_code: @result['result_code'],
        return_code: @result['return_code'],
        time_end: @result['time_end'],
        total_fee: @result['total_fee'],
        trade_type: @result['trade_type'],
        transaction_id: @result['transaction_id'] }
    end
  end
end