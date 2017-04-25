# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggerCreditTransactionsInsert < ActiveRecord::Migration[5.0]
  def up
    create_trigger("credit_transactions_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("credit_transactions").
        after(:insert) do
      <<-SQL_ACTIONS
      if (NEW.transaction_type = 'purchased' OR NEW.transaction_type = 'refunded' OR NEW.transaction_type = 'manual_addition') then
        update customers set credits_amount = credits_amount + NEW.amount WHERE id = NEW.customer_id;
      elsif (NEW.transaction_type = 'paid' OR NEW.transaction_type = 'manual_withdrawal') then
        update customers set credits_amount = credits_amount - NEW.amount WHERE id = NEW.customer_id;
      end if;
      SQL_ACTIONS
    end
  end

  def down
    drop_trigger("credit_transactions_after_insert_row_tr", "credit_transactions", :generated => true)
  end
end
