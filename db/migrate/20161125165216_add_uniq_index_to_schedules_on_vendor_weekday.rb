class AddUniqIndexToSchedulesOnVendorWeekday < ActiveRecord::Migration[5.0]
  def change
    add_index :schedules, [:vendor_id, :weekday], :unique => true
  end
end
