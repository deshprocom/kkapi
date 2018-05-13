module V1
  class InfosController < ApplicationController
    before_action :set_type, except: [:show]

    def index
      keyword = params[:keyword]
      @infos = @type.published_infos.page(params[:page]).per(params[:page_size])
                    .yield_self { |it| keyword ? it.search_keyword(keyword) : it }
    end

    def stickied
      @infos = @type.published_infos.stickied
      render 'index'
    end

    def show
      @info = Info.find(params[:id])
    end

    def set_type
      @type = InfoType.find_by!(slug: params[:info_type_id])
    end
  end
end
