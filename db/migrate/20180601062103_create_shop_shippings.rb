class CreateShopShippings < ActiveRecord::Migration[5.1]
  def change
    create_table :shop_shippings do |t|
      t.integer :express_id, comment: '快递id'
      t.string :name, comment: '运费模板名'
      t.string :calc_rule, comment:'计算类型 free_shipping: 免邮, weight: 按重量计费, number: 按件数计费'
      t.timestamps
      t.index [:express_id, :calc_rule], unique: true
    end
  end
end
