class AddTimestampsToSaleRoomRequest < ActiveRecord::Migration[5.1]
  def change
    add_timestamps(:sale_room_requests, null: true)
    add_column(:sale_room_requests, :passed_time, :datetime, comment: '审核通过时间，也是挂售的开始时间')
    add_column(:sale_room_requests, :withdrawn_time, :datetime, comment: '提现时间')
    add_column(:sale_room_requests, :refused_memo, :string, comment: '审核失败原因')
  end
end
