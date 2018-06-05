class ChangeVariantToDefaultFloat < ActiveRecord::Migration[5.1]
  def change
    execute "ALTER TABLE `shop_variants` CHANGE COLUMN `weight` `weight` decimal(11,3) DEFAULT 0.00 COMMENT '商品重量，计量单位为kg', CHANGE COLUMN `volume` `volume` decimal(11,2) DEFAULT 0.00 COMMENT '商品体积，计量单位为m3'"
  end
end
