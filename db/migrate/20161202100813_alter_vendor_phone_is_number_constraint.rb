class AlterVendorPhoneIsNumberConstraint < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE vendors
            DROP CONSTRAINT phone_is_number
        SQL

        execute <<-SQL
          ALTER TABLE vendors
            ADD CONSTRAINT phone_is_number
              CHECK (phone ~ '^\\+?[0-9]{7,11}$');
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE vendors
            ADD CONSTRAINT phone_is_number
              CHECK (phone ~ '^[0-9]{7,9}$');
        SQL
      end
    end
  end
end
