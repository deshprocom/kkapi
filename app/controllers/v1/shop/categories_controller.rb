module V1::Shop
  class CategoriesController < ApplicationController
    def index
      @categories = Shop::Category.roots.position_desc
    end

    def children
      @category = Shop::Category.find(params[:id])
    end
  end
end