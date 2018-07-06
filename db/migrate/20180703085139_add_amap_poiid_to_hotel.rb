class AddAmapPoiidToHotel < ActiveRecord::Migration[5.1]
  def change
    add_column :hotels, :amap_poiid, :string, limit: 30, comment: '高德地图的 POI地点的ID'
  end
end
