class ExtendWheelPrize < ActiveRecord::Migration[5.1]
  def change
    add_column :wheel_prizes, :image, :string, comment: '奖品图片'
    add_column :wheel_prizes, :face_value, :integer, comment: '奖品面值'
    add_column :wheel_user_prizes, :prize_type, :string,
               default: 'cheap',
               comment: 'cheap 小成本奖品，expensive 大成本奖品 free 无成本奖品'
  end
end
