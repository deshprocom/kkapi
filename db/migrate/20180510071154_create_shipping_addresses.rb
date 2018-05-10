class CreateShippingAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :shipping_addresses do |t|
      t.references :user
      t.string  :consignee, limit: 50, comment: '收货人'
      t.string  :province,  default: '', comment: '省份'
      t.string  :city,      default: '', comment: '城市'
      t.string  :area,      default: '', commnet: '区域'
      t.string  :address,              comment: '所在地'
      t.string  :mobile,    limit: 50, comment: '联系方式'
      t.string  :zip,                  comment: '邮政编码'
      t.boolean :default,  default: false, comment: '是否默认'
      t.string  :mark, default: '', comment: '备注'
      t.timestamps
    end
  end
end
