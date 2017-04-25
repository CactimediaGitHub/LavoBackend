class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer    :total,    null: false, default: 0
      t.string     :state,    index: true
      t.boolean    :openbasket, null: false, default: false, index: true
      t.references :vendor,   null: false, index: true
      t.references :customer, null: false, index: true
      t.timestamps
      # NOTE: need to find out operator class for timestamp without time zone or expression must be marked IMMUTABLE
      # t.index "date_trunc('month'::text, created_at::timestamptz)", name: "index_on_order_date_trunc_functional", using: :gist
    end
    add_foreign_key :orders, :vendors, on_delete: :cascade
    add_foreign_key :orders, :customers, on_delete: :cascade

    # reversible do |dir|
    #   dir.up do
    #     execute <<-SQL
    #       ALTER TABLE orders
    #         ADD CONSTRAINT positive_total
    #           CHECK (total > 0);
    #     SQL
    #   end
    #   dir.down do
    #     execute <<-SQL
    #       ALTER TABLE orders
    #         DROP CONSTRAINT positive_total
    #     SQL
    #   end
    # end
  end
end
