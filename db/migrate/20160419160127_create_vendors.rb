class CreateVendors < ActiveRecord::Migration[5.0]
  def change
    enable_extension :postgis
    create_table :vendors do |t|
      t.citext  :email,                 null: false
      t.string  :name,                  null: false
      t.string  :phone,                 null: false
      t.integer  :commission,           default: 10, null: false
      t.string  :address,               null: false
      t.float   :lat
      t.float   :lon
      t.string  :avatar
      t.string  :images, array: true,   default: []
      t.string  :password_digest
      t.string  :reset_digest
      t.datetime  :reset_sent_at
      t.string  :activation_digest
      t.boolean :activated,             default: false
      t.float   :cached_average_rating, default: 0.0
      t.integer :cached_total_reviews,  default: 0
      t.tsvector :tsv
      t.timestamps

      t.index "geography(st_setsrid(st_point(lat, lon), 4326))", name: "index_on_vendor_location", using: :gist
      t.index "st_setsrid(st_point(lat, lon), 4326)", name: "index_on_vendor_location_in_polygon", using: :gist
      t.index ["email"], name: "index_vendors_on_email", unique: true, using: :btree
      t.index ["tsv"], name: "index_vendors_on_tsv", using: :gin
    end

    reversible do |dir|
      dir.up do
        # execute "create index index_on_vendor_location on vendors using gist(geography(ST_SetSRID(ST_Point(lat,lon),4326)))"
        # execute "create index index_on_vendor_location_in_polygon on vendors using gist(ST_SetSRID(ST_Point(lat,lon),4326))"

        execute <<-SQL
          CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
          ON vendors FOR EACH ROW EXECUTE PROCEDURE
          tsvector_update_trigger(
            tsv, 'pg_catalog.english', name, address, phone, email
          );
        SQL
        execute("UPDATE vendors SET updated_at = '#{Time.current.to_s(:db)}'")

        execute <<-SQL
          ALTER TABLE vendors
            ADD CONSTRAINT phone_is_number
              CHECK (phone ~ '^[0-9]{7,9}$');
        SQL

        execute <<-SQL
          ALTER TABLE vendors
            ADD CONSTRAINT positive_commission
              CHECK (commission > 0);
        SQL
      end
      dir.down do
        # execute 'drop index index_on_vendor_location'
        # execute 'drop index index_on_vendor_location_in_polygon'

        execute <<-SQL
          DROP TRIGGER tsvectorupdate
          ON vendors
        SQL

        execute <<-SQL
          ALTER TABLE vendors
            DROP CONSTRAINT phone_is_number
        SQL

        execute <<-SQL
          ALTER TABLE vendors
            DROP CONSTRAINT positive_commission
        SQL

      end
    end

  end
end
