class AddAreaAndEmiratesFieldToVendors < ActiveRecord::Migration[5.0]
  def change
    add_column :vendors, :area, :string
    add_column :vendors, :emirate, :string
  end
end
