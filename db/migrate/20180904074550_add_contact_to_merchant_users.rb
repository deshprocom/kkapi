class AddContactToMerchantUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :merchant_users, :contact, :string, default: '', comment: '用户联系方式'
  end
end
