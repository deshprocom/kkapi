module V1
  class ExchangeRatesController < ApplicationController

    # 按现在的产品逻辑，默认只给出 CNY <=> HKD, CNY => MOP 的实时汇率
    def index
      optional! :exchange_type,
                values: ExchangeRate.rate_types.keys,
                default: 'real_time'

      self.send("#{params[:exchange_type]}_rates")
    end

    def receiving_rates
      @cny_to_hkd_rate = receiving_rate('CNY', 'HKD')
      @cny_to_mop_rate = receiving_rate('CNY', 'MOP')
    end

    def local_rates
      @cny_to_hkd_rate = local_rate('CNY', 'HKD')
      @cny_to_mop_rate = local_rate('CNY', 'MOP')
    end

    def receiving_rate(from, to)
      ExchangeRate.receiving.find_by!(s_currency_no: from, t_currency_no: to)
    end

    def local_rate(from, to)
      ExchangeRate.local.find_by!(s_currency_no: from, t_currency_no: to)
    end

    def real_time_rates
      @cny_to_hkd_rate = update_and_return_rate('CNY', 'HKD')
      @cny_to_mop_rate = update_and_return_rate('CNY', 'MOP')
    end

    # 1小时更新一次汇率
    def update_and_return_rate(from, to)
      rate = ExchangeRate.real_time.where(s_currency_no: from, t_currency_no: to).first_or_create
      return rate unless rate.updated_at < 1.hour.ago || rate.rate == 0.0

      result = RealTimeExchangeQuery.call(from, to)
      Rails.logger.info "RealTimeExchangeQuery result: #{result}"
      return rate unless result['error_code'] == 0

      # 手动更新时间，防止因rate没变化，而没有更新updated_at
      rate.update(rate: result['result'][0]['exchange'], updated_at: Time.now)
      rate
    end
  end
end
