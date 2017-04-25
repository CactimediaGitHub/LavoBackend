class ChangeForeignKeysForOrederPromotion < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :order_promotions, :orders
    remove_foreign_key :order_promotions, :promotions

    add_foreign_key :order_promotions, :orders, on_delete: :cascade
    add_foreign_key :order_promotions, :promotions, on_delete: :cascade
  end
end
