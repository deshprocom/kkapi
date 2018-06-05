class CreateShopShippingRegion < ActiveRecord::Migration[5.1]
  def change
    create_table :shop_shipping_regions do |t|
      t.references :shipping
      t.references :shipping_method
      t.string :region_name, limit: 60
      t.string :code, limit: 10, index: true, comment: '地区的code, 例如 广东省:440000 或 深圳市:440300 或 福田区: 440304'
    end
  end
end
