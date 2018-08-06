class AddCouponIdsAndMp3ToInfos < ActiveRecord::Migration[5.1]
  def change
    add_column :infos, :coupon_ids, :string, comment: '可领优惠券的ids, 用逗号分隔'
    add_column :infos, :audio_link, :string, comment: '音频链接'
  end
end
