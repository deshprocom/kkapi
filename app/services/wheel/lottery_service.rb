module Wheel
  class LotteryService
    include Serviceable
    def initialize(user, params)
      @user   = user
      @params = params
    end

    def call
      raise_error 'wheel_closed' if ENV['WHEEL_START'].eql?'false'
      raise_error 'wheel_times_limit' unless wheel_times_enough?
      # 开始准备抽奖
      # 记录用户抽奖次数
      @user.wheel_user_time.increase_today_times
      
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
      time = @user.wheel_user_time
      # 总剩余次数 是否大于 已抽取过的次数
      time.total_times > time.today_times
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
      prize = WheelPrize.free.sample
      prize_record = create_user_prize_record prize
      prize_record.to_used
      if prize.face_value.to_i > 0
        # 说明是积分 需要打给用户
        Integral.create_wheel_integral(user: @user,
                                       target: prize_record,
                                       points: prize.face_value.to_i)
      end
      prize
    end

    def giving_cheap_prize
      cheap_prize = WheelPrize.cheap.sample
      cheap_prize_count = create_or_find_cheap_count(cheap_prize)
      # 或者的cheap类型prize 每日限制，那么直接发放积分或者谢谢惠顾
      if cheap_prize_count.prize_number >= cheap_prize.limit_per_day
        return giving_free_prize
      end
      # 将小奖的对应的今日数量+1
      cheap_prize_count.increase_prize_number
      # 记录用户中奖情况
      prize_record = create_user_prize_record cheap_prize
      # 发放5，10元现金
      if cheap_prize.face_value.to_i > 0 && cheap_prize.face_value.to_i < 11
        PocketMoney.create_wheel_pocket_money(user: @user,
                                              target: prize_record,
                                              amount: cheap_prize.face_value.to_i)
        prize_record.to_used
      end
      cheap_prize
    end

    def create_or_find_cheap_count(prize)
      prize_count = prize.cheap_prize_counts.find_by(date: Date.current)
      return prize_count if prize_count.present?

      CheapPrizeCount.create(date: Date.current, wheel_prize: prize)
    end

    # 抽取大奖的流程
    def giving_expensive_prize(delay = false)
      prize_count = ExpensivePrizeCount.where(is_giving: false).where(delay: delay).order(id: :asc).first

      # 如果大奖不足 给与免费奖品
      return giving_free_prize if prize_count.blank?

      wheel_prize = prize_count.wheel_prize
      # 将大奖标记为已领取
      prize_count.update(is_giving: true)
      # 记录用户中了大奖
      create_user_prize_record wheel_prize
      wheel_prize
    end

    # 记录中奖情况
    def create_user_prize_record(prize)
      # 是否是大奖
      is_expensive = prize.expensive?
      WheelUserPrize.create(wheel_prize: prize,
                            user: @user,
                            is_expensive: is_expensive,
                            memo: prize.name,
                            prize_type: prize.prize_type)
    end
  end
end
