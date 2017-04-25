class EnablePostgis < ActiveRecord::Migration[5.0]
  def change
    # enable_extension :postgis
  end
  # def up
  #   ActiveRecord::Base.connection.execute('
  #     DROP EXTENSION IF EXISTS postgis CASCADE;
  #     DROP SCHEMA IF EXISTS postgis CASCADE;
  #
  #     CREATE SCHEMA postgis;
  #     CREATE EXTENSION postgis WITH SCHEMA postgis;
  #     GRANT ALL ON postgis.geometry_columns TO PUBLIC;
  #     GRANT ALL ON postgis.spatial_ref_sys TO PUBLIC;
  #     SET search_path TO public, postgis;
  #   ')
  # end
  #
  # def down
  #   ActiveRecord::Base.connection.execute('
  #     DROP EXTENSION IF EXISTS postgis CASCADE;'
  #   )
  # end
end
