class RemovePromotionAdjustedPercentFromOrders < ActiveRecord::Migration[5.0]
  def change
    remove_column :orders, :promotion_adjusted_percent
  end
end
