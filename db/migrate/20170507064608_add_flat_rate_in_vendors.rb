class AddFlatRateInVendors < ActiveRecord::Migration[5.0]
  def change
    add_column :vendors, :flat_rate, :integer, default: 0, null: false
  end
end
