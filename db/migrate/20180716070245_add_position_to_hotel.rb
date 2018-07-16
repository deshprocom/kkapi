class AddPositionToHotel < ActiveRecord::Migration[5.1]
  def change
    add_column :hotels, :position, :bigint, default: 0, comment: '用于拖拽排序'
  end
end
