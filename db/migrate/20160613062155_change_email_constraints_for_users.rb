class ChangeEmailConstraintsForUsers < ActiveRecord::Migration[5.0]
  def change
    change_column_null :customers, :email, false
    # change_column_null :vendors, :email, false
    # change_column_null :vendors, :address, false
    change_column_null :services, :name, false
    change_column_null :items, :name, false
  end
end
