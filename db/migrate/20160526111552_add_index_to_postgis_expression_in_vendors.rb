class AddIndexToPostgisExpressionInVendors < ActiveRecord::Migration[5.0]
  def up
    # execute "create index index_on_vendor_location on vendors using gist(geography(ST_SetSRID(ST_Point(lat,lon),4326)))"
  end

  def down
    # execute 'drop index index_on_vendor_location'
  end
end