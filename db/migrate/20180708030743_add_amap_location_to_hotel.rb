class AddAmapLocationToHotel < ActiveRecord::Migration[5.1]
  def change
    add_column :hotels, :amap_location, :string, limit: 32, comment: '高德的经纬度'
  end
end
