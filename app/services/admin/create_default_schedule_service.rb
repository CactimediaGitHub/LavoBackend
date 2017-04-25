module Admin
  class CreateDefaultScheduleService
    class << self
      def default_schedules
        @default_schedule ||= [
          Schedule.new(weekday: 'Sunday',    hours: normal_working_hours),
          Schedule.new(weekday: 'Monday',    hours: normal_working_hours),
          Schedule.new(weekday: 'Tuesday',   hours: normal_working_hours),
          Schedule.new(weekday: 'Wednesday', hours: normal_working_hours),
          Schedule.new(weekday: 'Thursday',  hours: normal_working_hours),
          Schedule.new(weekday: 'Friday',    hours: closed_all_day),
          Schedule.new(weekday: 'Saturday',  hours: closed_all_day)
        ]
      end

      private

      def closed_all_day
        @closed_all_day ||= {
        '0-2' => 'closed',
        '2-4' => 'closed',
        '4-6' => 'closed',
        '6-8' => 'closed',
        '8-10' => 'closed',
        '10-12' => 'closed',
        '12-14' => 'closed',
        '14-16' => 'closed',
        '16-18' => 'closed',
        '18-20' => 'closed',
        '20-22' => 'closed',
        '22-24' => 'closed'
        }.freeze
      end

      def normal_working_hours
        @normal_working_hours ||= {
          '0-2' => 'closed',
          '2-4' => 'closed',
          '4-6' => 'closed',
          '6-8' => 'closed',
          '8-10' => 'closed',
          '10-12' => 'open',
          '12-14' => 'open',
          '14-16' => 'open',
          '16-18' => 'open',
          '18-20' => 'closed',
          '20-22' => 'closed',
          '22-24' => 'closed'
        }.freeze
      end
    end
  end
end
