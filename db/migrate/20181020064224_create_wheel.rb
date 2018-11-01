class CreateWheel < ActiveRecord::Migration[5.1]
  def change
    # 转盘次数表
    create_table :wheel_user_times do |t|
      t.references :user
      t.integer    :today_times, default: 0, comment: '已抽次数总计'
      t.integer    :total_times, default: 0, comment: '可抽奖次数总计'
      t.timestamps
    end

    # 使用转盘的统计
    create_table :wheel_counts do |t|
      t.date    :date, comment: '日期'
      t.string  :count_type, default: 'daily', comment: 'daily 每日， total 总计'
      t.integer :new_user_count, default: 0, comment: '总的新增人数'
      t.integer :daily_new_user_count, default: 0, comment: '每日新增人数'
      t.integer :lottery_times, default: 0, comment: '每日的总抽奖次数'
      t.integer :lottery_users, default: 0, comment: '每日的总抽奖的用户数'
      t.timestamps
    end

    # 转盘组成的元素
    create_table :wheel_elements do |t|
      t.string  :name,     default: '', comment: '名称，例如：积分，充电宝，谢谢参与'
      t.string  :image,    default: '', comment: '例如：充电宝的图片，红包的图片'
      t.bigint  :position, default: 0,  comment: '用于拖拽排序'
      t.timestamps
    end

    # 转盘的奖品
    create_table :wheel_prizes do |t|
      t.references :wheel_element
      t.string  :prize_type,       default: 'cheap', comment: 'cheap 小成本奖品，expensive 大成本奖品 free 无成本奖品'
      t.string  :name,             default: '', comment: '名称，例如：cheap：10元现金，5元现金 expensive：双人星级酒店住宿, 双人澳门塔旋转自助餐  free：50积分，谢谢会顾'
      t.integer :limit_per_day,    default: 0, comment: '小奖品的每日限额'
      t.integer :generation_rule,  default: 0, comment: '产生规则：当达到一定的新增人数就产生多一个大奖'
      t.timestamps
    end

    # 统计每日小成本奖品的中奖情况
    create_table :cheap_prize_counts do |t|
      t.references :wheel_prize
      t.date       :date, comment: '日期'
      t.integer    :prize_number, default: 0, comment: '每日中奖的数量'
      t.timestamps
    end

    # 大成本奖品的产生记录
    create_table :expensive_prize_counts do |t|
      t.references :wheel_prize
      t.integer    :current_user_num, comment: '当前的用户数量'
      t.boolean    :is_giving, default: false, comment: '是否已被用户抽中'
      t.timestamps
    end

    # 用户抽奖记录表
    create_table :wheel_user_prizes do |t|
      t.references :wheel_prize
      t.references :user
      t.string     :memo, default: '', comment: '中奖说明'
      t.boolean    :used, default: false, comment: '奖品是否兑换了'
      t.boolean    :is_expensive, default: false, comment: '是否是大奖'
      t.datetime   :used_time, comment: '兑换时间'
      t.timestamps
    end
  end
end
