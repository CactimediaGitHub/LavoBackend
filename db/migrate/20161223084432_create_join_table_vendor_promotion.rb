class CreateJoinTableVendorPromotion < ActiveRecord::Migration[5.0]
  def change
    create_join_table :vendors, :promotions, table_name: 'vendor_promotions' do |t|
      t.index :vendor_id
      t.index :promotion_id
      t.index [:vendor_id, :promotion_id]
      t.index [:promotion_id, :vendor_id]
    end
    add_foreign_key :vendor_promotions, :promotions, on_delete: :cascade
    add_foreign_key :vendor_promotions, :vendors, on_delete: :cascade
  end
end
