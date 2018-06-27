class AddPayChannelToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :hotel_orders, :pay_channel, :string,
               limit: 15, default: 'weixin', comment: '支付渠道 weixin:微信支付 ali:支付宝支付'

    add_column :shop_orders, :pay_channel, :string,
               limit: 15, default: 'weixin', comment: '支付渠道 weixin:微信支付 ali:支付宝支付'
  end
end
