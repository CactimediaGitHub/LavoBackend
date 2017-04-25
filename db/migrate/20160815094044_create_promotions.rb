class CreatePromotions < ActiveRecord::Migration[5.0]
  def change
    create_table :promotions do |t|
      t.citext :name, null: false
      t.string :description
      t.string :icon
      t.datetime :starts_at, index: true
      t.datetime :expires_at, index: true
      t.timestamps
    end

    create_table :promotion_rules, force: :cascade do |t|
      t.integer  :promotion_id
      # t.integer  :vendor_id
      t.string   :type,             null: false
      t.datetime :created_at,       null: false
      t.datetime :updated_at,       null: false
      t.text     :preferences
    end
    add_foreign_key :promotion_rules, :promotions, on_delete: :cascade

    create_table :promotion_actions, force: :cascade do |t|
      t.integer  :promotion_id
      t.string   :type
      t.datetime :deleted_at, index: true
    end
    add_foreign_key :promotion_actions, :promotions, on_delete: :cascade

    create_table :calculators, force: :cascade do |t|
      t.string   :type
      t.integer  :calculable_id
      t.string   :calculable_type
      t.datetime :created_at,      null: false
      t.datetime :updated_at,      null: false
      t.text     :preferences
      t.datetime :deleted_at
    end

    create_table :adjustments, force: :cascade do |t|
      t.integer  :source_id
      t.string   :source_type
      t.integer  :adjustable_id
      t.string   :adjustable_type
      t.integer  :amount
      t.string   :label
      t.boolean  :eligible,                                 default: true
      t.datetime :created_at,                                               null: false
      t.datetime :updated_at,                                               null: false
      t.integer  :order_id,                                                 null: false
    end
    add_foreign_key :adjustments, :orders, on_delete: :cascade
  end
end
