class ChangeScheduleWeekdayType < ActiveRecord::Migration[5.0]
  def change
    change_column :schedules, :weekday, :citext, null: false
  end
end