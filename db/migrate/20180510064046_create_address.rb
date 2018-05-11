class CreateAddress < ActiveRecord::Migration[5.1]
  def change
    create_table :provinces do |t|
      t.string :name
      t.string :province_id
      t.timestamps
    end

    create_table :cities do |t|
      t.string :name
      t.string :city_id
      t.string :province_id
      t.timestamps
    end

    create_table :areas do |t|
      t.string :name
      t.string :area_id
      t.string :city_id
      t.timestamps
    end
  end
end
