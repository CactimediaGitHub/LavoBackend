class ModifyInventoryItemUniqIndex < ActiveRecord::Migration[5.0]
  def change
    remove_index :inventory_items, name: "index_inventory_items_on_vendor_id_and_service_id_and_item_id"
    add_index :inventory_items, [:vendor_id, :service_id, :item_id, :item_type_id], :unique => true, name: 'index_inventory_items_vendor_id_service_id_item_id_item_type_id'
  end
end
