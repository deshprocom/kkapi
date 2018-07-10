module Services
  module Integrals
    class TaskList
      include Serviceable

      def initialize(user)
        @user = user
      end

      def call # rubocop:disable Metrics/MethodLength
        @rules  = IntegralRule.where(opened: true).position_asc
        records = @user.integrals.where(category: 'tasks').today.order(created_at: :desc).group_by(&:option_type)

        @rules.collect do |rule|
          items = records[rule.option_type]
          done = 0
          doing = 0
          doing_points = 0
          done_points = 0

          items&.each do |item|
            if item.active_at.blank?
              doing += 1
              doing_points += item.points
            else
              done += 1
              done_points += item.points
            end
          end

          {
            option_type: rule.option_type,
            mark: rule.option_type_alias,
            limit_times: rule.limit_times,
            icon: rule.icon_path,
            point: rule.points,
            done: done,
            doing: doing,
            total_doing_points: doing_points,
            total_done_points: done_points,
            finished: done.eql?(rule.limit_times)
          }
        end
      end
    end
  end
end