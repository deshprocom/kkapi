module Services
  module Merchants
    class SaleRoomSms
      include Serviceable

      def initialize(user, params)
        @user = user
        @params = params
      end

      def call
        # 下发短信
        target_mobiles = ENV['SALE_ROOM_SMS_MOBILES']&.split(',')
        target_mobiles.each { |mobile| SendMobileIsmsJob.perform_later(mobile, sms_temp) }

        # 下发钉钉提醒
        conn = Faraday.new('https://oapi.dingtalk.com')
        conn.post do |req|
          req.url ENV['SALE_ROOM_SMS_URI']
          req.headers['Content-Type'] = 'application/json'
          req.body = payload
        end
      end

      def sms_temp
        "【澳门旅行APP】#{@user.nick_name}于#{time_now}上架了#{hotel_name}，房号：#{@params[:room_num]}， 联系方式：#{@user.contact}。请尽快核实处理，谢谢"
      end

      def time_now
        Time.zone.now.strftime('%Y-%m-%d %H:%M')
      end

      def hotel_name
        Hotel.find(@params[:hotel_id])&.title
      end

      def payload
        {
          "msgtype": "text",
          "text": {
              "content": sms_temp
          },
          "at": {
              "isAtAll": true
          }
        }.to_json
      end
    end
  end
end

