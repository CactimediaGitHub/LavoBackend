class AddPriceConstraintsToInventoryItems < ActiveRecord::Migration[5.0]
  def change

    reversible do |dir|
      dir.up do
        # add a CHECK constraint
        execute <<-SQL
          ALTER TABLE inventory_items
            ADD CONSTRAINT positive_price
              CHECK (price > 0);
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE inventory_items
            DROP CONSTRAINT positive_price
        SQL
      end
    end

  end
end
