class AddAdjustableAmountToOrders < ActiveRecord::Migration[5.0]
  def change
  	add_column :orders, :adjustable_amount, :float
  end
end
