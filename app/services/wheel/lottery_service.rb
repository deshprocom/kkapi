module Wheel
  class LotteryService
    include Serviceable
    def initialize(user, params)
      @user   = user
      @params = params
    end

    def call
      raise_error 'wheel_closed' unless ENV['WHEEL_START']
      raise_error 'wheel_times_limit' unless wheel_times_enough?
      # 开始准备抽奖
      # 如果该用户中过大奖 或者 大奖的库存为0 那么程序都直接进入小奖抽取
      if expensive_prize_exists? || expensive_prize_lists.count <= 0
        # 小奖
        giving_free_or_cheap_prize
      else
        giving_expensive_prize
      end
    end

    # 判断用户 抽奖次数是否充足
    def wheel_times_enough?
      time = create_or_find_wheel_times
      # 总剩余次数 是否大于 已抽取过的次数
      time.total_times > time.today_times
    end

    def create_or_find_wheel_times
      time = @user.wheel_user_time
      time.present? ? time : WheelUserTime.create(user: @user)
    end

    # 是否中过大奖
    def expensive_prize_exists?
      @user.wheel_user_prizes.where(is_expensive: true).exists?
    end

    # 找出可抽奖的奖品
    def expensive_prize_lists
      @expensive_prize = ExpensivePrizeCount.where(is_giving: false)
    end

    # 抽取小奖的流程
    def giving_free_or_cheap_prize
      rand = Random.rand(1..100)
      # 根据env配置的无成本奖品概率 算出范围
      free_rand_area = ENV['WHEEL_FREE_PROBABILITY'].to_f * 100
      rand <= free_rand_area ? giving_free_prize : giving_cheap_prize
    end

    def giving_free_prize
      WheelPrize.free.sample
    end

    def giving_cheap_prize
      cheap_prize = WheelPrize.cheap.sample
      cheap_prize_count = create_or_find_cheap_count(cheap_prize)
      # 或者的cheap类型prize 每日限制，那么直接发放积分或者谢谢惠顾
      if cheap_prize_count.prize_number >= cheap_prize.limit_per_day
        return giving_free_prize
      end
      # 发放5，10元现金或者餐券
      cheap_prize
    end

    def create_or_find_cheap_count(prize)
      prize_count = prize.cheap_prize_counts.find_by(date: Date.current)
      return prize_count if prize_count.present?

      CheapPrizeCount.create(date: Date.current, wheel_prize: prize)
    end

    # 抽取大奖的流程
    def giving_expensive_prize
      prize_count = ExpensivePrizeCount.where(is_giving: false).order(id: :asc).first
      prize_count.wheel_prize
    end
  end
end
