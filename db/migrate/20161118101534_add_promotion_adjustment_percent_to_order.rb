class AddPromotionAdjustmentPercentToOrder < ActiveRecord::Migration[5.0]
  def change
  	add_column :orders, :promotion_adjusted_percent, :float, default: 0.0
  end
end
