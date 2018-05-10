class CreateAdminImage < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_images do |t|
      t.references :imageable, polymorphic: true, index: true
      t.string 'image', comment: '图片链接'
      t.timestamps
    end
  end
end
