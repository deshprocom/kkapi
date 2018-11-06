class AddDescriptionToWheelPrize < ActiveRecord::Migration[5.1]
  def change
    add_column :wheel_prizes, :description, :text, comment: '奖品中奖说明'
  end
end
