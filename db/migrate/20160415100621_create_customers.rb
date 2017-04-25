class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    enable_extension :citext

    create_table :customers do |t|
      t.citext :email
      t.string :encrypted_password

      t.timestamps
    end
  end
end
