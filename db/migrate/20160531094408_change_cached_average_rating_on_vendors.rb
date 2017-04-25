class ChangeCachedAverageRatingOnVendors < ActiveRecord::Migration[5.0]
  def change
    # remove_column :vendors, :cached_average_rating
    # add_column :vendors, :cached_average_rating, :float, default: 0.0
  end
end