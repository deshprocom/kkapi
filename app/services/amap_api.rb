class AmapApi
  def initialize
    @amap_key = ENV['AMAP_KEY']
  end

  # 需要搜索的IP地址（仅支持国内）
  def get_ip_location(ip)
    url = "https://restapi.amap.com/v3/ip?ip=#{ip}&key=#{@amap_key}"
    get_result(url)
  end

  def get_location(location, platform)
    Rails.logger.info "AmapApi: current location: #{location}"
    if platform == 'ios'
      result = convert_location(location)
      Rails.logger.info "AmapApi: convert_location result: #{result}"
      location = result['locations'] if result['locations']
    end
    url = "http://restapi.amap.com/v3/geocode/regeo?location=#{location}{&key=#{@amap_key}"
    get_result(url)
  end

  def convert_location(location)
    url = "http://restapi.amap.com/v3/assistant/coordinate/convert?locations=#{location}&key=#{@amap_key}&coordsys=gps"
    get_result(url)
  end

  def get_result(url)
    response = RestClient::Request.execute(url: url, method: :get)
    JSON.parse(response.body)
  end
end
