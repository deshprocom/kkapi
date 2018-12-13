module V1::Shop
  class OneYuanBuysController < ApplicationController
    include UserAuthorize
    before_action :current_user

    def index
      optional! :type, values: %w[going past], default: 'going'
      @buys = buys_scope.visible
                .order(begin_time: :asc)
                .page(params[:page]).per(params[:page_size])
                .includes(:product)
    end

    def buys_scope
      Shop::OneYuanBuy
        .yield_self { |it| params[:type] == 'going' ?
                             it.where('end_time >= ?', Time.current):
                             it.where('end_time < ?', Time.current) }
    end
  end
end