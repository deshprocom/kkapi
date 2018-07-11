class AddLoginDaysToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :user_counters, :login_days, :integer, default: 0, comment: '登录天数'
    add_column :user_counters, :continuous_login_days, :integer, default: 0, comment: '连续登录天数'
  end
end
