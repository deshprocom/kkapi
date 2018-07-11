class AddMarkToCoupons < ActiveRecord::Migration[5.1]
  def change
    add_column :coupons, :mark, :string, default: '', comment: '备注'
  end
end
