class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    enable_extension :hstore

    create_table :payments do |t|
      t.integer :paid_amount, null: false, default: 0
      t.integer :credits_amount, default: 0
      t.integer :order_total, default: 0
      t.string :status, index: true
      t.string :response_code
      t.string :response_message
      t.string :fort_id
      t.string :uuid
      t.string :confirmation_url
      t.hstore :response, :response, null: false, default: {}
      # t.string :state,     null: false, index: true
      t.references :order, index: true
      t.references :customer, null: false, index: true
      t.references :vendor, index: true
      t.references :card, index: true

      t.timestamps
    end
    # add_foreign_key :payments, :orders, on_delete: :cascade
    # add_foreign_key :payments, :vendors, on_delete: :cascade
    add_foreign_key :payments, :customers, on_delete: :cascade

    reversible do |dir|
      dir.up do
        execute <<-SQL
          CREATE TYPE payment_method AS ENUM ('card', 'credits', 'card_credits', 'cash');
        SQL
      end
      dir.down do
        execute <<-SQL
          DROP TYPE payment_method;
        SQL
      end
    end
    add_column :payments, :payment_method, :payment_method, null: false, default: 'cash'


    # reversible do |dir|
    #   dir.up do
    #     execute <<-SQL
    #       ALTER TABLE payments
    #         ADD CONSTRAINT positive_amount
    #           CHECK (paid_amount > 0);
    #     SQL
    #   end
    #   dir.down do
    #     execute <<-SQL
    #       ALTER TABLE payments
    #         DROP CONSTRAINT positive_amount
    #     SQL
    #   end
    # end

  end
end
