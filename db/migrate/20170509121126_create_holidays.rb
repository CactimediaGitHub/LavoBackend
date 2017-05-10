class CreateHolidays < ActiveRecord::Migration[5.0]
  def change
    create_table :holidays do |t|
      t.datetime :holiday_date
      t.references :vendor, index: true

      t.timestamps
    end
  end
end
