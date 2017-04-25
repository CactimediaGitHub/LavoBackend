class CreateJoinTableVendorService < ActiveRecord::Migration[5.0]
  def change
    create_join_table :vendors, :services, table_name: :vendor_services do |t|
      t.index :vendor_id
      t.index :service_id
    end
  end
end
