class CreateShopShippingInfo < ActiveRecord::Migration[5.1]
  def change
    create_table :shop_shipping_infos do |t|
      t.references :order
      t.string :name, comment: '收货人姓名'
      t.string :province
      t.string :city
      t.string :area
      t.string :address
      t.string :mobile
      t.string :zip
      t.string :change_reason, comment: '后台修改地址的原因'
      t.string :memo,          comment: '修改备注'
      t.timestamps
    end
  end
end
