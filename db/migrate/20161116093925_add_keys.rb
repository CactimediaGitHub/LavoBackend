class AddKeys < ActiveRecord::Migration
  def change
    add_foreign_key "order_promotions", "orders", name: "order_promotions_order_id_fk"
    add_foreign_key "order_promotions", "promotions", name: "order_promotions_promotion_id_fk"
  end
end
