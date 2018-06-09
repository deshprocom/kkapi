module Services
  module Integrals
    class RecordService
      include Serviceable

      def initialize(user, type, options = {})
        @user = user
        @type = type
        @target = options[:target]
        @category = options[:category] || 'tasks' # 默认是任务奖励
        @integral_rule = IntegralRule.find_by(option_type: @type)
      end

      def call
        return if @integral_rule.blank? || !@integral_rule.opened? || limited?

        Integral.create(create_params)
      end

      private

      def limited?
        current_times = Integral.where(user_id: @user.id).where(option_type: @type).today.count
        return false if @integral_rule.limit_times <= 0
        current_times >= @integral_rule.limit_times
      end

      def create_params
        {
          user_id: @user.id,
          option_type: @type,
          target: @target,
          category: @category,
          points: @integral_rule.points,
          mark: @integral_rule.option_type_alias
        }
      end
    end
  end
end