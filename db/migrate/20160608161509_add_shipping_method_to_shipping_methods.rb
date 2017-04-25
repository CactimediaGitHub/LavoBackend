class AddShippingMethodToShippingMethods < ActiveRecord::Migration[5.0]
  def change
    # reversible do |dir|
    #   dir.up do
    #     execute <<-SQL
    #       CREATE TYPE shipping_method AS ENUM ('normal', 'express');
    #     SQL
    #   end
    #   dir.down do
    #     execute <<-SQL
    #       DROP TYPE shipping_method;
    #     SQL
    #   end
    # end
    # add_column :shipping_methods, :shipping_method, :shipping_method, null: false, default: 'normal'
    # add_index :shipping_methods, [:shipping_method, :vendor_id], :unique => true
  end
end