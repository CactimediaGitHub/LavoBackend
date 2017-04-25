class DropTableServiceRules < ActiveRecord::Migration[5.0]
  def change
    drop_table :service_rules
  end
end
