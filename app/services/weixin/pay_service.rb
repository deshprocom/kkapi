module Weixin
  class PayService
    include Serviceable
    def initialize(order, client_ip, trade_source = 'app')
      @order = order
      @client_ip = client_ip
      @trade_source = trade_source
    end

    def call
      raise_error_msg '当前状态不能支付' unless @order.unpaid?

      result = WxPay::Service.invoke_unifiedorder(pay_params)
      Rails.logger.info pay_params
      unless result.success?
        # 微信统一下单失败
        Rails.logger.info("WX_PAY ERROR number=#{@order.order_number}: #{result}")
        raise_error_msg '微信支付失败'
      end
      # 生成唤起支付需要的参数
      generate_app_pay_req(result)
    end

    private

    def pay_params
      if @trade_source == 'miniprogram'
        option = {
          trade_type: 'JSAPI',
          appid: ENV['MINIPROGRAM_APP_ID'],
          openid: @order.user.weixin_user.miniprogram_openid
        }
      else
        option = {
          trade_type: 'APP',
          appid: ENV['WX_APP_ID']
        }
      end
      {
        body: "#{@order.pay_title}：#{@order.order_number}",
        out_trade_no: @order.order_number,
        total_fee: (@order.final_price * 100).to_i,
        spbill_create_ip: @client_ip,
        notify_url: notify_url,
      }.merge(option)
    end

    def generate_app_pay_req(result)
      appid = ENV['WX_APP_ID']
      appid = ENV['MINIPROGRAM_APP_ID'] if @trade_source == 'miniprogram'
      params = {
        prepayid: result['prepay_id'],
        noncestr: result['nonce_str'],
        appid: appid
      }
      WxPay::Service.generate_app_pay_req(params)
    end

    def notify_url
      "#{ENV['HOST_URL']}/v1/weixin/notify/#{@order.model_name.singular}"
    end
  end
end
