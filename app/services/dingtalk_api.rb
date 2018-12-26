class DingtalkApi
  class << self
    def hotel_order_notify(text)
      url = ENV['HOTEL_NOTIFY_DINGTALK']
      payload = {
        msgtype: 'text',
        text: { content: text },
        at: { isAtAll: false }
      }
      post(url, payload)
    end

    def post(url, payload)
      RestClient.post(url, payload.to_json, content_type: :json, timeout: 5)
    end
  end
end
