class CreateOrderItems < ActiveRecord::Migration[5.0]
  def change
    # NOTE: arhive inventory_items, not delete
    create_table :order_items do |t|
      t.integer :quantity,          null: false, default: 0
      t.references :order,          null: false, index: true
      t.references :inventory_item, null: false, index: true

      t.timestamps
    end
    add_foreign_key :order_items, :orders, on_delete: :cascade
    add_foreign_key :order_items, :inventory_items

    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE order_items
            ADD CONSTRAINT positive_quantity
              CHECK (quantity > 0);
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE order_items
            DROP CONSTRAINT positive_quantity
        SQL
      end
    end
  end
end
