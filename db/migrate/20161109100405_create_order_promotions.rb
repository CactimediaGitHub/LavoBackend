class CreateOrderPromotions < ActiveRecord::Migration[5.0]
  def change
    create_table :order_promotions do |t|
      t.references :order
      t.references :promotion
      t.timestamps
    end
  end
end
