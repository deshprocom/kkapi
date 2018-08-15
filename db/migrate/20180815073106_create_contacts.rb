class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.string :name, default: '', comment: '官方称呼'
      t.string :mobile, default: '', comment: '官方手机号'
      t.string :email, default: '', comment: '官方邮箱'
      t.timestamps
    end
  end
end
