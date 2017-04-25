class AddFkVendorReferencesToPromotionRules < ActiveRecord::Migration[5.0]
  def change
    # add_foreign_key :promotion_rules, :vendors, column: :vendor_id, primary_key: :id
  end
end
