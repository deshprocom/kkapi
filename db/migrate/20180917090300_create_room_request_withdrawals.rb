class CreateRoomRequestWithdrawals < ActiveRecord::Migration[5.1]
  def change
    create_table :room_request_withdrawals do |t|
      t.references :merchant_user
      t.references :sale_room_request
      t.decimal    :price, precision: 15, scale: 2, default: '0.0', comment: '挂售金额'
      t.string     :status, limit: 32, default: 'pending', comment: '申请状态 pending 审核中， passed 已通过， refused 不通过'
      t.timestamps
    end
  end
end
