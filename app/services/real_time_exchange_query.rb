class RealTimeExchangeQuery
  include Serviceable
  def initialize(from, to)
    @response = Faraday.get('http://op.juhe.cn/onebox/exchange/currency',
                key: '1868ae01f9baee1e17a8348591381266',
                from: from,
                to: to,)
  end

  def call
    JSON.parse @response.body
  end
end
