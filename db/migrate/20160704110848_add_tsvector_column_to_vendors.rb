class AddTsvectorColumnToVendors < ActiveRecord::Migration[5.0]
  def change
    # add_column :vendors, :tsv, :tsvector
    # add_index :vendors, :tsv, using: "gin"

    reversible do |dir|
      dir.up do
        # execute <<-SQL
        #   CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
        #   ON vendors FOR EACH ROW EXECUTE PROCEDURE
        #   tsvector_update_trigger(
        #     tsv, 'pg_catalog.english', name, address
        #   );
        # SQL
        # execute("UPDATE vendors SET updated_at = '#{Time.current.to_s(:db)}'")
      end
      dir.down do
        # execute <<-SQL
        #   DROP TRIGGER tsvectorupdate
        #   ON vendors
        # SQL
      end
    end

  end
end
