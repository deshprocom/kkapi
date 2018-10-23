class CreateSaunas < ActiveRecord::Migration[5.1]
  def change
    create_table :saunas do |t|
      t.string :title
      t.string :location
      t.string :logo
      t.string :telephone, length: 100
      t.integer :star_level, limit: 2, default: 4, comment: '星级'
      t.string :amap_poiid, limit: 30, comment: '高德地图的 POI地点的ID'
      t.string :amap_location, limit: 32, comment: '高德的经纬度'
      t.decimal :latitude, precision: 15, scale: 6, index: true
      t.decimal :longitude, precision: 15, scale: 6, index: true
      t.bigint :position, default: 0, comment: '用于拖拽排序'
      t.decimal :price, precision: 11, scale: 2, default: '0.0', comment: '人均价格'
      t.boolean :published, default: false, comment: '是否发布'
      t.text :description
      t.timestamps
    end
  end
end
