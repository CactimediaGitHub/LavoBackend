class AddPasswordDigestToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :password_digest, :string
    remove_column :customers, :encrypted_password, :string
  end
end