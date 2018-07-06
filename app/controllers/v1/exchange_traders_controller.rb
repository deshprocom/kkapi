module V1
  class ExchangeTradersController < ApplicationController
    def index
      @traders = ExchangeTrader
                   .includes(:user).order(position: :desc)
                   .page(params[:page]).per(params[:page_size])
    end
  end
end
