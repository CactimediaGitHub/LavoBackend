class CreateSchedules < ActiveRecord::Migration[5.0]
  def change
    enable_extension :hstore
    create_table :schedules do |t|
      t.string :weekday, null: false
      t.hstore :hours,
               null: false,
               default: {
                 '0-2' => 'open',
                 '2-4' => 'open',
                 '4-6' => 'open',
                 '6-8' => 'open',
                 '8-10' => 'open',
                 '10-12' => 'open',
                 '12-14' => 'open',
                 '14-16' => 'open',
                 '16-18' => 'open',
                 '18-20' => 'open',
                 '20-22' => 'open',
                 '22-24' => 'open'
               }
      t.references :vendor, index: true

      t.timestamps
    end
    add_index :schedules, :hours, using: :gin
    add_foreign_key :schedules, :vendors, on_delete: :cascade
  end
end
