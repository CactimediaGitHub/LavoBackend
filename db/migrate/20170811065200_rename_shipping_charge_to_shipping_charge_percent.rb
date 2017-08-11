class RenameShippingChargeToShippingChargePercent < ActiveRecord::Migration[5.0]
  def change
  	rename_column :shipping_methods, :shipping_charge, :shipping_charge_percent
  end
end
