class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :address1,   null: false
      t.string :address2
      t.string :city,       null: false
      t.string :country,    null: false
      t.string :postcode
      t.string :human_name, null: false
      t.references :customer, index: true

      t.timestamps
    end
    add_foreign_key :addresses, :customers, on_delete: :cascade
  end
end
