class CreateInfoType < ActiveRecord::Migration[5.1]
  def change
    create_table :info_types do |t|
      t.string  :name
      t.boolean :published,  default: false
      t.timestamps
    end
  end
end
