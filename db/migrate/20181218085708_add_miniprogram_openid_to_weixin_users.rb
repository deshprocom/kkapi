class AddMiniprogramOpenidToWeixinUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :weixin_users, :miniprogram_openid, :string, comment: '小程序的openid'
  end
end
