class CreateCards < ActiveRecord::Migration[5.0]
  def change
    create_table :cards do |t|
      t.string :number, null: false, default:''
      t.string :token, null: false, default:''
      t.string :card_bin, null: false, default:''
      t.string :name, null: false, default:''
      t.string :expiry_date, null: false, default:''
      t.string :nick, null: false, default:''
      t.references :customer, null: false, index: true

      t.timestamps
      t.index ["customer_id", "token"], name: "index_uniq_customer_token_on_cards", unique: true, using: :btree
    end
    add_foreign_key :cards, :customers, on_delete: :cascade
    add_foreign_key :payments, :cards, on_delete: :cascade
  end
end
