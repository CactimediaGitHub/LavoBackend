class AddAccountFieldsToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :avatar, :string
    add_column :customers, :name, :string
    add_column :customers, :surname, :string
    add_column :customers, :phone, :string
  end
end
