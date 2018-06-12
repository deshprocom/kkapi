class CreateHotelRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :hotel_rooms do |t|
      t.references :hotel
      t.string :title
      t.string :text_tags, comment: '以json数组的形式存tag文字'
      t.string :text_notes, comment: '以json数组的形式存note文字'
      t.boolean :published, default: false, comment: '是否发布'
    end
  end
end
