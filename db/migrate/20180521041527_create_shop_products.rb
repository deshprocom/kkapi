class CreateShopProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :shop_products do |t|
      t.references :category
      t.string :title
      t.text :description
      t.boolean :published, default: false, comment: '是否上架'
      t.boolean :recommended, default: false, comment: '是否推荐'
      t.boolean :returnable, default: false, comment: '是否支持退货'
      t.timestamps
    end
  end
end
