class AddExpireDayToCoupon < ActiveRecord::Migration[5.1]
  def change
    add_column :coupon_temps, :expire_day, :integer, default: 30, comment: '优惠券有效时间'
    remove_column :coupons, :expire_day
  end
end
