module V1
  class InfosController < ApplicationController
    before_action :set_type

    def index

    end

    def show
    end

    def set_type
      @type = InfoType.find_by!(slug: params[:info_type_id])
    end
  end
end
