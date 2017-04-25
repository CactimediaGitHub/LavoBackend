class CreateServiceRules < ActiveRecord::Migration[5.0]
  def change
    create_join_table :services, :items, table_name: :service_rules do |t|
      t.index :service_id
      t.index :item_id
    end
  end
end
