class ChangeCachedTotalReviewsOnVendors < ActiveRecord::Migration[5.0]
  def change
    # remove_column :vendors, :cached_total_reviews
    # add_column :vendors, :cached_total_reviews, :integer, default: 0
  end
end
