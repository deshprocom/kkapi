class CreateShopShippingMethods < ActiveRecord::Migration[5.1]
  def change
    create_table :shop_shipping_methods do |t|
      t.references :parent, default: 0, comment: '默认计算方式的parent_id为0， 指定区域的邮费计算方式的parent_id为默认计算方式的id'
      t.string :name, comment: '运费模板名'
      t.string :code, limit: 10, index: true, comment: '地区的code, 例如 广东省:440000 或 深圳市:440300 或 福田区: 440304'
      t.decimal :first_item,  precision: 12, scale: 4, default: '0.0', comment: '首项(首重 或 首件等)'
      t.decimal :first_price, precision: 12, scale: 4, default: '0.0', comment: '首项价格'
      t.decimal :add_item, precision: 12, scale: 4, default: '0.0', comment: '续项(续重 或 续件等)'
      t.decimal :add_price, precision: 12, scale: 4, default: '0.0', comment: '续项价格'
      t.timestamps
    end
  end
end
