class AddWeekPricesToHotel < ActiveRecord::Migration[5.1]
  def up
    %w[sun mon tue wed thu fri sat].each do |wday|
      add_column :hotels, "#{wday}_min_price", :decimal, precision: 11, scale: 2, default: 0, comment: '星期几的最低价'
    end
    remove_column :hotels, :start_price
  end

  def down
    %w[sun mon tue wed thu fri sat].each do |wday|
      remove_column :hotels, "#{wday}_min_price"
    end
    add_column :hotels, :start_price, :decimal, precision: 11, scale: 2, default: 0, comment: '起始价'
  end
end
