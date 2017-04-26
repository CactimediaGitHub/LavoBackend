class AddColumnPrefixNumberToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :prefix_phone, :text, default: '050'
  end
end
