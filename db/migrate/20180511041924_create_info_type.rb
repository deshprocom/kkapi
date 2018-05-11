class CreateInfoType < ActiveRecord::Migration[5.1]
  def change
    create_table :info_types do |t|
      t.string  :name
      t.string  :slug, comment: '用于url别名'
      t.boolean :published,  default: false
      t.timestamps
    end
  end
end
