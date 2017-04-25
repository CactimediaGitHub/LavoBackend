class CreateInventoryItems < ActiveRecord::Migration[5.0]
  def change
    create_table :item_types do |t|
      t.string :name
      t.timestamps
    end

    create_table :inventory_items do |t|
      t.integer   :price, null: false, default: 0
      t.references :vendor,  index: true, null: false
      t.references :item,    index: true, null: false
      t.references :item_type, index: true, null: false
      t.references :service, index: true, null: false
      t.timestamps
    end
    add_index :inventory_items, :price
    add_index :inventory_items, [:vendor_id, :service_id, :item_id], :unique => true

    add_foreign_key :inventory_items, :vendors, on_delete: :cascade
    add_foreign_key :inventory_items, :items, on_delete: :cascade
    add_foreign_key :inventory_items, :item_types, on_delete: :cascade
    add_foreign_key :inventory_items, :services, on_delete: :cascade
  end
end
