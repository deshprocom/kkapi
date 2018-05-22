module V1::Shop
  class CategoriesController < ApplicationController
    def index
      @categories = Shop::Category.roots
    end

    def children
      @category = Shop::Category.find(params[:id])
    end
  end
end