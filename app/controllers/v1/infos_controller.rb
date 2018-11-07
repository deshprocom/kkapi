module V1
  class InfosController < ApplicationController
    include UserAuthorize
    before_action :set_type, only: [:stickied, :index]
    before_action :set_info, only: [:show, :coupons, :receive_coupon]
    before_action :login_required, only: [:coupons, :receive_coupon]
    before_action :current_user, only: [:show]

    def index
      keyword = params[:keyword]
      @infos = @type.published_infos.page(params[:page]).per(params[:page_size])
                    .yield_self { |it| keyword ? it.search_keyword(keyword) : it }
    end

    def all
      keyword = params[:keyword]
      @infos = Info.where(published: true).order(id: :desc)
                 .page(params[:page]).per(params[:page_size])
                 .yield_self { |it| keyword ? it.search_keyword(keyword) : it }
      render 'index'
    end

    def stickied
      @infos = @type.published_infos.stickied
      render 'index'
    end

    def show
      # 浏览量 +1
      @info.increase_page_views
    end

    def coupons
      @coupons = @info.coupons
    end

    def receive_coupon
      coupon_ids = @info.coupon_ids.to_s.split(',')
      raise_error'coupon_not_exist' unless params[:coupon_id].to_s.in?(coupon_ids)
      if Coupon.user_received?(@current_user.id, params[:coupon_id])
        raise_error'coupon_already_receive'
      end

      coupon_temp = CouponTemp.find(params[:coupon_id])
      Coupon.create(coupon_temp: coupon_temp).received_by_user(@current_user)
      render_api_success
    end

    def set_type
      @type = InfoType.find_by!(slug: params[:info_type_id])
    end

    def set_info
      @info = Info.find(params[:id])
    end
  end
end
