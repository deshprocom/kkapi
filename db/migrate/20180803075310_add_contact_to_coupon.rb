class AddContactToCoupon < ActiveRecord::Migration[5.1]
  def change
    add_column :coupon_temps, :telephone, :string, comment: '联系电话'
    add_column :coupon_temps, :address, :string, comment: '地址'
  end
end
