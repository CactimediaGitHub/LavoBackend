class AddTsvToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :tsv, :tsvector
    add_index :customers, :tsv, using: :gin

    reversible do |dir|

      dir.up do
        execute <<-SQL
          CREATE TRIGGER tsv_update_customers BEFORE INSERT OR UPDATE
          ON customers FOR EACH ROW EXECUTE PROCEDURE
          tsvector_update_trigger(
            tsv, 'pg_catalog.english', name, surname, phone, email
          );
        SQL
        execute("UPDATE customers SET updated_at = '#{Time.current.to_s(:db)}'")
      end

      dir.down do
        execute <<-SQL
          DROP TRIGGER tsv_update_customers
          ON customers
        SQL
      end

    end

  end
end