class DropVendorServices < ActiveRecord::Migration[5.0]
  def change
    drop_table :vendor_services
  end
end
