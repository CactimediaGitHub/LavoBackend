class CreateShippings < ActiveRecord::Migration[5.0]
  def change
    # NOTE: arhive shipping_methods, addresses, not delete
    create_table :shippings do |t|
      t.tstzrange :pick_up,          null: false
      t.tstzrange :drop_off,         null: false
      t.references :order,           null: false, index: true
      t.references :shipping_method,              index: true
      t.references :address,         null: false, index: true
      t.timestamps
    end
    add_foreign_key :shippings, :orders, on_delete: :cascade
    add_foreign_key :shippings, :shipping_methods
    # add_foreign_key :shippings, :addresses
  end
end
