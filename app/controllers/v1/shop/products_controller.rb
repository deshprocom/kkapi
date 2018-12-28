module V1::Shop
  class ProductsController < ApplicationController
    include UserAuthorize
    before_action :current_user

    def index
      keyword = params[:keyword].presence
      category_id = params[:category_id].presence
      @products = product_scope.page(params[:page]).per(params[:page_size])
                               .yield_self { |it| keyword ? it.search_keyword(keyword) : it }
                               .yield_self { |it| category_id ? it.in_category(category_id) : it }
    end

    def recommended
      @products = product_scope.recommended.page(params[:page]).per(params[:page_size])
      render 'index'
    end

    def discounts
      @products = product_scope.where(visible_discounts_list: true)
                    .page(params[:page]).per(params[:page_size])
      render 'index'
    end

    def show
      @product = product_scope.find(params[:id])
    end

    def product_scope
      Shop::Product.published.position_desc
    end
  end
end