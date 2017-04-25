class AddUniqEmailIndexToUsers < ActiveRecord::Migration[5.0]
  def change
    add_index :customers, [:email], :unique => true
    # add_index :vendors, [:email], :unique => true
  end
end