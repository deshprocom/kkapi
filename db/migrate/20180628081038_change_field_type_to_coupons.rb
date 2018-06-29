class ChangeFieldTypeToCoupons < ActiveRecord::Migration[5.1]
  def change
    remove_column :coupons, :coupon_status
    add_column :coupons, :coupon_status, :string, default: 'init', comment: 'init初始化 unused未使用, used已使用, refund已使用被退回可重新用'
    add_index :coupons, :coupon_status

    remove_column :coupons, :close_time
    add_column :coupons, :pay_time, :datetime, comment: '优惠券付款的时间'
  end
end
