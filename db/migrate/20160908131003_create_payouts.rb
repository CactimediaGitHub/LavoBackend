class CreatePayouts < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          CREATE TYPE payout_type AS ENUM ('pending', 'partial', 'completed');
        SQL
      end
      dir.down do
        execute <<-SQL
          DROP TYPE payout_type;
        SQL
      end
    end

    create_table :payouts do |t|
      t.integer :amount,    null: false, default: 0
      t.string :note
      t.references :vendor, null: false, index: true

      t.timestamps
    end
    add_foreign_key :payouts, :vendors, on_delete: :cascade
    add_column :payouts, :payment_status, :payout_type, null: false, default: 'pending'

    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE payouts
            ADD CONSTRAINT positive_amount
              CHECK (amount > 0);
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE payouts
            DROP CONSTRAINT positive_amount
        SQL
      end
    end

    add_column :vendors, :balance, :integer, null: false, default: 0
  end
end
