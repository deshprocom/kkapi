class DropFieldDescFromCoupon < ActiveRecord::Migration[5.1]
  def change
    remove_column :coupon_temps, :description
  end
end
