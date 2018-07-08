class AddRegionToHotel < ActiveRecord::Migration[5.1]
  def change
    add_column :hotels, :region, :string, limit: 32, comment: '酒店地区 dangzai: 氹仔区, aomenbandao 澳门半岛'
  end
end
