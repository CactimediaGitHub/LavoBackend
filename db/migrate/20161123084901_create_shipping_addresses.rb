class CreateShippingAddresses < ActiveRecord::Migration[5.0]
  def change
    remove_column :shippings, :address_id

    create_table :shipping_addresses do |t|
      t.string :address1,   null: false
      t.string :address2
      t.string :city,       null: false
      t.string :country,    null: false
      t.string :postcode
      t.string :human_name, null: false
      t.references :shipping, index: true

      t.timestamps
    end
    add_foreign_key :shipping_addresses, :shippings, on_delete: :cascade
  end
end