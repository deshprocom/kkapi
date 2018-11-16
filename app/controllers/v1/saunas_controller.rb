module V1
  class SaunasController < ApplicationController
    def index
      requires! :latitude
      requires! :longitude
      @saunas = Sauna.near([params[:latitude], params[:longitude]], 5000)
    end

    def access_permission
      requires! :latitude
      requires! :longitude
      amap_api = AmapApi.new
      location = amap_api.get_location("#{params[:longitude]},#{params[:latitude]}")
      ip_location = amap_api.get_ip_location(request.env['HTTP_X_FORWARDED_FOR'])

      # 高德说明：city为空，说明不在中国大陆
      # 1853是澳门的city code
      # 不在大陆并且city code在澳门则可以访问桑拿
      if ip_location['city'].blank? && location['regeocode']['addressComponent']['citycode'].to_i == 1853
        render_api_success
      else
        render_api_error('不在澳门')
      end
    end

    def show
      @sauna = Sauna.find(params[:id])
    end
  end
end
