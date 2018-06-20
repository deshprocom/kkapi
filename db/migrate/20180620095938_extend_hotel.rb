class ExtendHotel < ActiveRecord::Migration[5.1]
  def change
    add_column :hotels, :start_price, :decimal, precision: 11, scale: 2, default: 0, comment: '起始价'
    add_column :hotels, :star_level, :integer, default: 4, limit: 2, comment: '星级'
  end
end
