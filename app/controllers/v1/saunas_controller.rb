module V1
  class SaunasController < ApplicationController
    def index
      requires! :latitude
      requires! :longitude
      @saunas = Sauna.near([params[:latitude], params[:longitude]], 5000)
    end

    def show
      @sauna = Sauna.find(params[:id])
    end
  end
end
