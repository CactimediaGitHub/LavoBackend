class AddFkConstraintsToInventoryItems < ActiveRecord::Migration[5.0]
  def change
    # add_foreign_key :inventory_items, :vendors, on_delete: :cascade
    # add_foreign_key :inventory_items, :items, on_delete: :cascade
    # add_foreign_key :inventory_items, :item_typess, on_delete: :cascade
    # add_foreign_key :inventory_items, :services, on_delete: :cascade
  end
end
