class AddUniqIndexToInventory < ActiveRecord::Migration[5.0]
  def change
    # add_index :inventory_items, [:vendor_id, :service_id, :item_id], :unique => true
  end
end