class ExtendWheelUserPrizes < ActiveRecord::Migration[5.1]
  def change
    add_column :wheel_user_prizes, :used_memo, :string,
               limit: 1024,
               comment: '兑奖备注'
  end
end
