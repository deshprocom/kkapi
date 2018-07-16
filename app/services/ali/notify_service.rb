module Ali
  class NotifyService
    include Serviceable

    def initialize(order, result)
      @order = order
      @result = result
      Rails.logger.info "Ali::NotifyService order_number(#{result['out_trade_no']}): #{result}"
    end

    # https://docs.open.alipay.com/204/105301/
    # 1、商户需要验证该通知数据中的out_trade_no是否为商户系统中创建的订单号，
    # 2、判断total_amount是否确实为该订单的实际金额（即商户订单创建时的金额），
    # 3、校验通知中的seller_id（或者seller_email) 是否为out_trade_no这笔单据的对应的操作方（有的时候，一个商户可能有多个seller_id/seller_email），
    # 4、验证app_id是否为该商户本身。上述1、2、3、4有任何一个验证不通过，则表明本次通知是异常通知，务必忽略。
    # 在上述验证通过后商户必须根据支付宝不同类型的业务通知，正确的进行不同的业务处理，并且过滤重复的通知结果数据。
    # 在支付宝的业务通知中，只有交易通知状态为TRADE_SUCCESS或TRADE_FINISHED时，支付宝才会认定为买家付款成功。
    def call
      # 该订单已经支付过，就不需要接下来的验证了
      return if @order.pay_status == 'paid'

      return 'fail' unless $alipay.verify?(@result)

      return unless @result['total_amount'].to_f == @order.final_price.to_f

      return unless @result['app_id'] == ENV['ALIPAY_APP_ID']

      return unless @result['seller_id'] == ENV['ALIPAY_SELLER_ID']

      return unless @result['trade_status'].in?(%w[TRADE_SUCCESS TRADE_FINISHED])

      order_to_paid
      got_integral
    end

    def order_to_paid
      if @order.class.name == 'HotelOrder'
        HotelServices::OrderToPaid.call(@order, 'ali')
      else
        Shop::OrderToPaidService.call(@order, 'ali')
      end
    end

    def got_integral
      Integral.create_paid_to_integral(user: @order.user,
                                       target: @order,
                                       price: @order.final_price,
                                       option_type: @order.model_name.singular)
    end
  end
end