module V1
  class ExchangeTradersController < ApplicationController
    def index
      optional! :trader_type, values: ExchangeTrader.trader_types.keys, default: 'ex_rate'
      @traders = ExchangeTrader.where(trader_type: params[:trader_type])
                   .includes(:user).order(score: :desc)
                   .page(params[:page]).per(params[:page_size])
    end
  end
end
