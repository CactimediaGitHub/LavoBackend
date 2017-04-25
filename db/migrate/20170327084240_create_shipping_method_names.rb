class CreateShippingMethodNames < ActiveRecord::Migration[5.0]
  def change
    create_table :shipping_method_names do |t|
      t.citext :name, null: false

      t.timestamps
    end

    add_column :shipping_methods, :shipping_method_name_id, :integer, index: true
    add_index :shipping_methods, [:shipping_method_name_id, :vendor_id], :unique => true
    add_foreign_key :shipping_methods, :shipping_method_names
  end
end