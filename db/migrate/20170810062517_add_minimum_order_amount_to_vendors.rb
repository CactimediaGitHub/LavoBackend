class AddMinimumOrderAmountToVendors < ActiveRecord::Migration[5.0]
  def change
  	add_column :vendors, :minimum_order_amount, :float, default: 0.0
  end
end
