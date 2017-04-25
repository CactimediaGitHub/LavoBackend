class AddIndexToShippingMethod < ActiveRecord::Migration[5.0]
  def change
    # reversible do |dir|
    #   dir.up do
    #     execute <<-SQL
    #       create index index_shipping_methods_on_normal_shipping_method on shipping_methods (shipping_method) where shipping_method = 'normal';
    #       create index index_shipping_methods_on_express_shipping_method on shipping_methods (shipping_method) where shipping_method = 'express';
    #     SQL
    #   end
    #   dir.down do
    #     execute <<-SQL
    #       DROP index index_shipping_methods_on_normal_shipping_method;
    #       DROP index index_shipping_methods_on_express_shipping_method;
    #     SQL
    #   end
    # end

  end
end
