class AddActivationToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :activation_digest, :string
    add_column :customers, :activated, :boolean, default: false
    # add_column :vendors, :activation_digest, :string
    # add_column :vendors, :activated, :boolean, default: false
  end
end
