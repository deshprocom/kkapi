class CreateShopShippingMethods < ActiveRecord::Migration[5.1]
  def change
    create_table :shop_shipping_methods do |t|
      t.references :shipping
      t.string :name
      t.decimal :first_item,  precision: 12, scale: 4, default: '0.0', comment: '首项(首重 或 首件等)'
      t.decimal :first_price, precision: 12, scale: 4, default: '0.0', comment: '首项价格'
      t.decimal :add_item, precision: 12, scale: 4, default: '0.0', comment: '续项(续重 或 续件等)'
      t.decimal :add_price, precision: 12, scale: 4, default: '0.0', comment: '续项价格'
      t.boolean :default_method, defualt: false, comment: '默认的计费方式'
      t.timestamps
    end
  end
end
