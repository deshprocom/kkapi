class AddIntroToProduct < ActiveRecord::Migration[5.1]
  def change
    add_column :shop_products, :intro, :string, comment: '商品简介'
  end
end
