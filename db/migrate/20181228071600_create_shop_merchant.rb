class CreateShopMerchant < ActiveRecord::Migration[5.1]
  def change
    create_table :shop_merchants do |t|
      t.string :name, limit: 50, comment: '商家名称'
      t.string :telephone, limit: 50, comment: '商家电话'
      t.string :location, comment: '商家地址'
      t.string :amap_poiid, limit: 30, comment: '高德地图的 POI地点的ID'
      t.string :amap_location, limit: 50, comment: '高德的经纬度(gcj02坐标系)'
    end
  end
end
