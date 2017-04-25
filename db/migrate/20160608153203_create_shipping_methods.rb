class CreateShippingMethods < ActiveRecord::Migration[5.0]
  def change
    create_table :shipping_methods do |t|
      t.integer :shipping_charge, null: false, default: 0
      t.integer :delivery_period, null: false, default: 0
      t.references :vendor, index: true

      t.timestamps
    end
    add_foreign_key :shipping_methods, :vendors, on_delete: :cascade

    reversible do |dir|
      dir.up do
        # add a CHECK constraint
        execute <<-SQL
          ALTER TABLE shipping_methods
            ADD CONSTRAINT positive_shipping_charge
              CHECK (shipping_charge > 0);
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE shipping_methods
            DROP CONSTRAINT positive_shipping_charge
        SQL
      end
    end

  end
end
