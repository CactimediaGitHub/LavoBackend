class ChangeColumnPostcodeToNearestLandmark < ActiveRecord::Migration[5.0]
  def change
  	rename_column :addresses, :postcode, :nearest_landmark
  	rename_column :shipping_addresses, :postcode, :nearest_landmark
  end
end
