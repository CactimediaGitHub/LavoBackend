# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggerPayoutsInsert < ActiveRecord::Migration
  def up
    create_trigger("payouts_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("payouts").
        after(:insert) do
      "      update vendors set balance = balance - NEW.amount WHERE id = NEW.vendor_id;"
    end
  end

  def down
    drop_trigger("payouts_after_insert_row_tr", "payouts", :generated => true)
  end
end
