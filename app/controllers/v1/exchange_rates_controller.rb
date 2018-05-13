module V1
  class ExchangeRatesController < ApplicationController
    def index
      @rates = ExchangeRate.limit(10)
    end
  end
end
