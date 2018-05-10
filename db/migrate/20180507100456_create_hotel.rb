class CreateHotel < ActiveRecord::Migration[5.1]
  def change
    create_table :hotels do |t|
      t.string :title
      t.string :location
      t.string :logo
      t.string :telephone, length: 100
      t.boolean :published, default: false, comment: '是否发布'
      t.text :description
      t.timestamps
    end
  end
end
