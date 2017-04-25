class AddIndexOnLocationInPolygonToVendors < ActiveRecord::Migration[5.0]
  def up
    # execute "create index index_on_vendor_location_in_polygon on vendors using gist(ST_SetSRID(ST_Point(lat,lon),4326))"
  end

  def down
    # execute 'drop index index_on_vendor_location_in_polygon'
  end
end
