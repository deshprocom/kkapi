class AddExtToMobileTables < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :ext, :string, default: '86', comment: '国家区号'
    add_column :sms_logs, :ext, :string, default: '86', comment: '国家区号'
  end
end
