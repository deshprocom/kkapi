class CreateCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :coupon_temps do |t|
      t.string     :name,          default: '',    comment: '优惠券名字'
      t.string     :short_desc,    default: '',    comment: '简单描述'
      t.string     :cover_link,    default: '',    comment: '优惠券封面'
      t.string     :coupon_type,   comment: '优惠券类别:酒店hotel，商城shop'
      t.string     :discount_type, comment: '折扣类别: reduce立减，full_reduce满减，rebate打折'
      t.integer    :limit_price,   default: 0, comment: '满多少减'
      t.integer    :reduce_price,  default: 0, comment: '减的价格'
      t.decimal    :discount,      precision: 3,   scale: 2, default: '0.0', comment: '折扣'
      t.boolean    :new_user,      default: false, comment: '所否是新用户所有'
      t.boolean    :integral_on,   default: false, comment: '是否开启积分兑换'
      t.integer    :integrals,     default: 0,     comment: '需要的积分'
      t.integer    :coupons_count, default: 0,     comment: '优惠券总数量'
      t.integer    :coupon_received_count, default: 0, comment: '优惠券已领取数量'
      t.boolean    :published,     default: false, comment: '是否发布'
      t.text       :description,                   comment: "图文内容"
      t.timestamps
    end
    add_index :coupon_temps, [:published]
    add_index :coupon_temps, [:new_user, :published]
    add_index :coupon_temps, [:integral_on, :published]

    create_table :coupons do |t|
      t.references :coupon_temp
      t.string     :coupon_number,  limit: 32, null: false, comment: '优惠券编号', index: true
      t.integer    :expire_day,     comment: '有效天数'
      t.datetime   :expire_time,    comment: '失效日期'
      t.datetime   :receive_time,   comment: '领取时间'
      t.references :user,           comment: '优惠券属于哪个用户'
      t.string     :target_type,    comment: '优惠券使用的目标'
      t.integer    :target_id,      comment: '优惠券使用的目标'
      t.datetime   :close_time,     comment: '优惠券被使用的时间'
      t.datetime   :refund_time,    comment: '优惠券被退回的时间'
      t.string     :coupon_status,  default: 'open', comment: 'open未使用, close已使用, refund已使用被退回可重新用'
      t.timestamps
    end
    add_index :coupons, [:expire_time]
  end
end
