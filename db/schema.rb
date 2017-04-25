# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170327084240) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"
  enable_extension "pgcrypto"
  enable_extension "postgis"
  enable_extension "hstore"

  create_table "addresses", force: :cascade do |t|
    t.string   "address1",    null: false
    t.string   "address2"
    t.string   "city",        null: false
    t.string   "country",     null: false
    t.string   "postcode"
    t.string   "human_name",  null: false
    t.integer  "customer_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["customer_id"], name: "index_addresses_on_customer_id", using: :btree
  end

  create_table "adjustments", force: :cascade do |t|
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "adjustable_id"
    t.string   "adjustable_type"
    t.integer  "amount"
    t.string   "label"
    t.boolean  "eligible",        default: true
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "order_id",                       null: false
  end

  create_table "calculators", force: :cascade do |t|
    t.string   "type"
    t.integer  "calculable_id"
    t.string   "calculable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.text     "preferences"
    t.datetime "deleted_at"
  end

  create_table "cards", force: :cascade do |t|
    t.string   "number",      default: "", null: false
    t.string   "token",       default: "", null: false
    t.string   "card_bin",    default: "", null: false
    t.string   "name",        default: "", null: false
    t.string   "expiry_date", default: "", null: false
    t.string   "nick",        default: "", null: false
    t.integer  "customer_id",              null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["customer_id", "token"], name: "index_uniq_customer_token_on_cards", unique: true, using: :btree
    t.index ["customer_id"], name: "index_cards_on_customer_id", using: :btree
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
    t.index ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree
  end

# Could not dump table "credit_transactions" because of following StandardError
#   Unknown type 'credit_transaction_type' for column 'transaction_type'

  create_table "customers", force: :cascade do |t|
    t.citext   "email",                             null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "avatar"
    t.string   "name"
    t.string   "surname"
    t.string   "phone"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.integer  "credits_amount",    default: 0,     null: false
    t.tsvector "tsv"
    t.index ["email"], name: "index_customers_on_email", unique: true, using: :btree
    t.index ["tsv"], name: "index_customers_on_tsv", using: :gin
  end

  create_table "http_tokens", force: :cascade do |t|
    t.uuid     "key",            default: -> { "gen_random_uuid()" }, null: false
    t.string   "tokenable_type"
    t.integer  "tokenable_id"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.index ["key"], name: "index_http_tokens_on_key", unique: true, using: :btree
    t.index ["tokenable_type", "tokenable_id"], name: "index_http_tokens_on_tokenable_type_and_tokenable_id", using: :btree
  end

  create_table "inventory_items", force: :cascade do |t|
    t.integer  "price",        default: 0, null: false
    t.integer  "vendor_id",                null: false
    t.integer  "item_id",                  null: false
    t.integer  "item_type_id",             null: false
    t.integer  "service_id",               null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["item_id"], name: "index_inventory_items_on_item_id", using: :btree
    t.index ["item_type_id"], name: "index_inventory_items_on_item_type_id", using: :btree
    t.index ["price"], name: "index_inventory_items_on_price", using: :btree
    t.index ["service_id"], name: "index_inventory_items_on_service_id", using: :btree
    t.index ["vendor_id", "service_id", "item_id", "item_type_id"], name: "index_inventory_items_vendor_id_service_id_item_id_item_type_id", unique: true, using: :btree
    t.index ["vendor_id"], name: "index_inventory_items_on_vendor_id", using: :btree
  end

  create_table "item_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notification_registrations", force: :cascade do |t|
    t.string   "notifiable_type",                null: false
    t.integer  "notifiable_id",                  null: false
    t.boolean  "notify",          default: true, null: false
    t.string   "token",                          null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_pn_registrations_on_notifiable_type_and_notifiable_id", using: :btree
    t.index ["token"], name: "index_notification_registrations_on_token", unique: true, using: :btree
  end

  create_table "notifications", force: :cascade do |t|
    t.string   "notifiable_type", null: false
    t.integer  "notifiable_id",   null: false
    t.string   "message",         null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_type_and_notifiable_id", using: :btree
  end

  create_table "order_items", force: :cascade do |t|
    t.integer  "quantity",          default: 0, null: false
    t.integer  "order_id",                      null: false
    t.integer  "inventory_item_id",             null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["inventory_item_id"], name: "index_order_items_on_inventory_item_id", using: :btree
    t.index ["order_id"], name: "index_order_items_on_order_id", using: :btree
  end

  create_table "order_promotions", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "promotion_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["order_id"], name: "index_order_promotions_on_order_id", using: :btree
    t.index ["promotion_id"], name: "index_order_promotions_on_promotion_id", using: :btree
  end

  create_table "order_transitions", force: :cascade do |t|
    t.string   "to_state",                 null: false
    t.json     "metadata",    default: {}
    t.integer  "sort_key",                 null: false
    t.integer  "order_id",                 null: false
    t.boolean  "most_recent",              null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["order_id", "most_recent"], name: "index_order_transitions_parent_most_recent", unique: true, where: "most_recent", using: :btree
    t.index ["order_id", "sort_key"], name: "index_order_transitions_parent_sort", unique: true, using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "total",            default: 0,     null: false
    t.string   "state"
    t.boolean  "openbasket",       default: false, null: false
    t.integer  "vendor_id",                        null: false
    t.integer  "customer_id",                      null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "promotion_amount", default: 0,     null: false
    t.integer  "subtotal",         default: 0,     null: false
    t.integer  "shipping_amount",  default: 0,     null: false
    t.index ["customer_id"], name: "index_orders_on_customer_id", using: :btree
    t.index ["openbasket"], name: "index_orders_on_openbasket", using: :btree
    t.index ["state"], name: "index_orders_on_state", using: :btree
    t.index ["vendor_id"], name: "index_orders_on_vendor_id", using: :btree
  end

  create_table "pages", force: :cascade do |t|
    t.citext   "nick",                    null: false
    t.string   "title",      default: "", null: false
    t.text     "body",       default: "", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

# Could not dump table "payments" because of following StandardError
#   Unknown type 'payment_method' for column 'payment_method'

# Could not dump table "payouts" because of following StandardError
#   Unknown type 'payout_type' for column 'payment_status'

  create_table "promotion_actions", force: :cascade do |t|
    t.integer  "promotion_id"
    t.string   "type"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_promotion_actions_on_deleted_at", using: :btree
  end

  create_table "promotion_rules", force: :cascade do |t|
    t.integer  "promotion_id"
    t.string   "type",         null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.text     "preferences"
  end

  create_table "promotions", force: :cascade do |t|
    t.citext   "name",                             null: false
    t.string   "description"
    t.string   "icon"
    t.datetime "starts_at"
    t.datetime "expires_at"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "background_image"
    t.string   "match_policy",     default: "all"
    t.index ["expires_at"], name: "index_promotions_on_expires_at", using: :btree
    t.index ["starts_at"], name: "index_promotions_on_starts_at", using: :btree
  end

  create_table "reviews", force: :cascade do |t|
    t.string   "reviewable_type",            null: false
    t.integer  "reviewable_id",              null: false
    t.string   "reviewer_type",              null: false
    t.integer  "reviewer_id",                null: false
    t.string   "ip",              limit: 24
    t.float    "rating"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["body"], name: "index_reviews_on_body", using: :btree
    t.index ["rating"], name: "index_reviews_on_rating", using: :btree
    t.index ["reviewable_id", "reviewable_type"], name: "index_reviews_on_reviewable_id_and_reviewable_type", using: :btree
    t.index ["reviewable_type", "reviewable_id"], name: "index_reviews_on_reviewable_type_and_reviewable_id", using: :btree
    t.index ["reviewable_type"], name: "index_reviews_on_reviewable_type", using: :btree
    t.index ["reviewer_id", "reviewer_type"], name: "index_reviews_on_reviewer_id_and_reviewer_type", using: :btree
    t.index ["reviewer_type", "reviewer_id"], name: "index_reviews_on_reviewer_type_and_reviewer_id", using: :btree
  end

  create_table "schedules", force: :cascade do |t|
    t.citext   "weekday",                                                                                                                                                                                                                  null: false
    t.hstore   "hours",      default: {"0-2"=>"open", "2-4"=>"open", "4-6"=>"open", "6-8"=>"open", "8-10"=>"open", "10-12"=>"open", "12-14"=>"open", "14-16"=>"open", "16-18"=>"open", "18-20"=>"open", "20-22"=>"open", "22-24"=>"open"}, null: false
    t.integer  "vendor_id"
    t.datetime "created_at",                                                                                                                                                                                                               null: false
    t.datetime "updated_at",                                                                                                                                                                                                               null: false
    t.index ["hours"], name: "index_schedules_on_hours", using: :gin
    t.index ["vendor_id", "weekday"], name: "index_schedules_on_vendor_id_and_weekday", unique: true, using: :btree
    t.index ["vendor_id"], name: "index_schedules_on_vendor_id", using: :btree
  end

  create_table "services", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shipping_addresses", force: :cascade do |t|
    t.string   "address1",    null: false
    t.string   "address2"
    t.string   "city",        null: false
    t.string   "country",     null: false
    t.string   "postcode"
    t.string   "human_name",  null: false
    t.integer  "shipping_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["shipping_id"], name: "index_shipping_addresses_on_shipping_id", using: :btree
  end

  create_table "shipping_method_names", force: :cascade do |t|
    t.citext   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shipping_methods", force: :cascade do |t|
    t.integer  "shipping_charge",         default: 0, null: false
    t.integer  "delivery_period",         default: 0, null: false
    t.integer  "vendor_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "shipping_method_name_id"
    t.index ["shipping_method_name_id", "vendor_id"], name: "index_shipping_methods_on_shipping_method_name_id_and_vendor_id", unique: true, using: :btree
    t.index ["vendor_id"], name: "index_shipping_methods_on_vendor_id", using: :btree
  end

  create_table "shippings", force: :cascade do |t|
    t.tstzrange "pick_up",            null: false
    t.tstzrange "drop_off",           null: false
    t.integer   "order_id",           null: false
    t.integer   "shipping_method_id"
    t.datetime  "created_at",         null: false
    t.datetime  "updated_at",         null: false
    t.index ["order_id"], name: "index_shippings_on_order_id", using: :btree
    t.index ["shipping_method_id"], name: "index_shippings_on_shipping_method_id", using: :btree
  end

  create_table "spatial_ref_sys", primary_key: "srid", id: :integer, force: :cascade do |t|
    t.string  "auth_name", limit: 256
    t.integer "auth_srid"
    t.string  "srtext",    limit: 2048
    t.string  "proj4text", limit: 2048
  end

  create_table "vendor_promotions", id: false, force: :cascade do |t|
    t.integer "vendor_id",    null: false
    t.integer "promotion_id", null: false
    t.index ["promotion_id", "vendor_id"], name: "index_vendor_promotions_on_promotion_id_and_vendor_id", using: :btree
    t.index ["promotion_id"], name: "index_vendor_promotions_on_promotion_id", using: :btree
    t.index ["vendor_id", "promotion_id"], name: "index_vendor_promotions_on_vendor_id_and_promotion_id", using: :btree
    t.index ["vendor_id"], name: "index_vendor_promotions_on_vendor_id", using: :btree
  end

  create_table "vendors", force: :cascade do |t|
    t.citext   "email",                                 null: false
    t.string   "name",                                  null: false
    t.string   "phone",                                 null: false
    t.integer  "commission",            default: 10,    null: false
    t.string   "address",                               null: false
    t.float    "lat"
    t.float    "lon"
    t.string   "avatar"
    t.string   "images",                default: [],                 array: true
    t.string   "password_digest"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "activation_digest"
    t.boolean  "activated",             default: false
    t.float    "cached_average_rating", default: 0.0
    t.integer  "cached_total_reviews",  default: 0
    t.tsvector "tsv"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "balance",               default: 0,     null: false
    t.index "geography(st_setsrid(st_point(lat, lon), 4326))", name: "index_on_vendor_location", using: :gist
    t.index "st_setsrid(st_point(lat, lon), 4326)", name: "index_on_vendor_location_in_polygon", using: :gist
    t.index ["email"], name: "index_vendors_on_email", unique: true, using: :btree
    t.index ["tsv"], name: "index_vendors_on_tsv", using: :gin
  end

  add_foreign_key "addresses", "customers", on_delete: :cascade
  add_foreign_key "adjustments", "orders", on_delete: :cascade
  add_foreign_key "cards", "customers", on_delete: :cascade
  add_foreign_key "credit_transactions", "customers", on_delete: :cascade
  add_foreign_key "inventory_items", "item_types", on_delete: :cascade
  add_foreign_key "inventory_items", "items", on_delete: :cascade
  add_foreign_key "inventory_items", "services", on_delete: :cascade
  add_foreign_key "inventory_items", "vendors", on_delete: :cascade
  add_foreign_key "order_items", "inventory_items"
  add_foreign_key "order_items", "orders", on_delete: :cascade
  add_foreign_key "order_promotions", "orders", on_delete: :cascade
  add_foreign_key "order_promotions", "promotions", on_delete: :cascade
  add_foreign_key "order_transitions", "orders", on_delete: :cascade
  add_foreign_key "orders", "customers", on_delete: :cascade
  add_foreign_key "orders", "vendors", on_delete: :cascade
  add_foreign_key "payments", "cards", on_delete: :cascade
  add_foreign_key "payments", "customers", on_delete: :cascade
  add_foreign_key "payouts", "vendors", on_delete: :cascade
  add_foreign_key "promotion_actions", "promotions", on_delete: :cascade
  add_foreign_key "promotion_rules", "promotions", on_delete: :cascade
  add_foreign_key "schedules", "vendors", on_delete: :cascade
  add_foreign_key "shipping_addresses", "shippings", on_delete: :cascade
  add_foreign_key "shipping_methods", "shipping_method_names"
  add_foreign_key "shipping_methods", "vendors", on_delete: :cascade
  add_foreign_key "shippings", "orders", on_delete: :cascade
  add_foreign_key "shippings", "shipping_methods"
  add_foreign_key "vendor_promotions", "promotions", on_delete: :cascade
  add_foreign_key "vendor_promotions", "vendors", on_delete: :cascade
  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute("CREATE TRIGGER tsv_update_customers BEFORE INSERT OR UPDATE ON \"customers\" FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('tsv', 'pg_catalog.english', 'name', 'surname', 'phone', 'email')")

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute(<<-TRIGGERSQL)
CREATE OR REPLACE FUNCTION pg_catalog.tsvector_update_trigger()
 RETURNS trigger
 LANGUAGE internal
 PARALLEL SAFE
AS $function$tsvector_update_trigger_byid$function$
  TRIGGERSQL

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute("CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON \"vendors\" FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('tsv', 'pg_catalog.english', 'name', 'address', 'phone', 'email')")

  create_trigger("credit_transactions_after_insert_row_tr", :generated => true, :compatibility => 1).
      on("credit_transactions").
      after(:insert) do
    <<-SQL_ACTIONS
      if (NEW.transaction_type = 'purchased' OR NEW.transaction_type = 'refunded' OR NEW.transaction_type = 'manual_addition') then
        update customers set credits_amount = credits_amount + NEW.amount WHERE id = NEW.customer_id;
      elsif (NEW.transaction_type = 'paid' OR NEW.transaction_type = 'manual_withdrawal') then
        update customers set credits_amount = credits_amount - NEW.amount WHERE id = NEW.customer_id;
      end if;
    SQL_ACTIONS
  end

  create_trigger("payouts_after_insert_row_tr", :generated => true, :compatibility => 1).
      on("payouts").
      after(:insert) do
    "      update vendors set balance = balance - NEW.amount WHERE id = NEW.vendor_id;"
  end

end
