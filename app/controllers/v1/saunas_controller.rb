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
      Rails.logger.info "SaunasController: HTTP_X_FORWARDED_FOR: #{request.env['HTTP_X_FORWARDED_FOR']},"
      Rails.logger.info "SaunasController: ip_location: #{ip_location},"

      # 高德说明：city为空，说明不在中国大陆
      # 1853是澳门的city code
      # 因为经纬度的误差，可能会使珠海的经度度变成澳门，则做以下的兼容处理
      # ip地址不是广东省的并且cityCode定们在澳门则可以访问桑拿
      if ip_location['province'] != '广东省' && location['regeocode']['addressComponent']['citycode'].to_i == 1853
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
