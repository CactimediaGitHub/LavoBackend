class AddResetPassAttrsToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :reset_digest, :string
    add_column :customers, :reset_sent_at, :datetime
    # add_column :vendors, :reset_digest, :string
    # add_column :vendors, :reset_sent_at, :datetime
  end
end
