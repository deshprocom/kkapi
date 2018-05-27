class CreateProductCounter < ActiveRecord::Migration[5.1]
  def change
    create_table :shop_product_counters do |t|
      t.references :product
      t.integer :page_view, default: 0, comment: '浏览量'
      t.integer :sales_volume,  default: 0, comment: '销售量'
    end

    Shop::Product.all.each do |p|
      p.create_counter
    end
  end
end
