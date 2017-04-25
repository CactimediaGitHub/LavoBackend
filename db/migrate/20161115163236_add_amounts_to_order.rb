class AddAmountsToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :promotion_amount, :integer, null: false, default: 0
    add_column :orders, :subtotal,         :integer, null: false, default: 0
    add_column :orders, :shipping_amount,  :integer, null: false, default: 0
  end
end
