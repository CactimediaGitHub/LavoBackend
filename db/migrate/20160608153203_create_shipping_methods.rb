class CreateShippingMethods < ActiveRecord::Migration[5.0]
  def change
    create_table :shipping_methods do |t|
      t.integer :shipping_charge, null: false, default: 0
      t.integer :delivery_period, null: false, default: 0
      t.references :vendor, index: true

      t.timestamps
    end
    add_foreign_key :shipping_methods, :vendors, on_delete: :cascade
  end
end
