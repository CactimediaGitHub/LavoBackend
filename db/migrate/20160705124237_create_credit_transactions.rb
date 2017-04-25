class CreateCreditTransactions < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          CREATE TYPE credit_transaction_type AS ENUM ('purchased', 'refunded', 'paid', 'manual_addition', 'manual_withdrawal');
        SQL
      end
      dir.down do
        execute <<-SQL
          DROP TYPE credit_transaction_type;
        SQL
      end
    end

    create_table :credit_transactions do |t|
      t.integer :amount, null: false, default: 0
      t.string :note, null: false, default: ''
      t.references :customer, null: false, index: true

      t.timestamps
    end
    add_foreign_key :credit_transactions, :customers, on_delete: :cascade
    add_column :credit_transactions, :transaction_type, :credit_transaction_type, null: false, default: 'paid'

    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE credit_transactions
            ADD CONSTRAINT positive_amount
              CHECK (amount > 0);
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE credit_transactions
            DROP CONSTRAINT positive_amount
        SQL
      end
    end

    add_column :customers, :credits_amount, :integer, null: false, default: 0

  end
end
