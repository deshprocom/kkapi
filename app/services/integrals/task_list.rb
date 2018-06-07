module Services
  module Integrals
    class TaskList
      include Serviceable

      def initialize(user)
        @user = user
      end

      def call
        records = @user.integrals.where(category: 'tasks').today.order(created_at: :desc).group_by { |t| t.option_type }
        records.collect do |item|
          done = 0
          doing = 0
          doing_points = 0
          done_points = 0
          integral_rule = IntegralRule.find_by(option_type: item.first)
          next if integral_rule.blank? || !integral_rule.opened

          item.last.each do |val|
            if val.active_at.blank?
              doing += 1
              doing_points += val.points
            else
              done += 1
              done_points += val.points
            end
          end

          {
            option_type: item.first,
            done: done,
            doing: doing,
            limit_times: integral_rule.limit_times,
            mark: integral_rule.option_type_alias,
            total_doing_points: doing_points,
            total_done_points: done_points,
            finished: done.eql?(integral_rule.limit_times)
          }
        end
      end
    end
  end
end