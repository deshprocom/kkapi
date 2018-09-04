class CreateMerchantUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :merchant_users do |t|
      t.string   :user_uuid,    limit: 32, null: false,    comment: '用户的uuid'
      t.string   :nick_name,    limit: 32,                 comment: '用户的昵称'
      t.string   :mobile,                  default: '',    comment: '用户手机号'
      t.string   :ext,                     default: '86',  comment: '手机区号'
      t.string   :password,     limit: 32,                 comment: '用户的密码'
      t.string   :password_salt,           default: '',    comment: '密码盐值'
      t.boolean  :blocked,                 default: false, comment: '是否被拉入黑名单'
      t.datetime :blocked_at,                              comment: '被拉入黑名单时间'
      t.datetime :last_visit,                              comment: '上次登录时间'
      t.string   :mark,                                    comment: '备注'
      t.timestamps
    end
    add_index :merchant_users, [:mobile]
  end
end
