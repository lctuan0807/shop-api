# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_06_01_041205) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: :cascade do |t|
    t.string "key", null: false
    t.boolean "status", default: true, null: false
    t.string "permissions", default: [], null: false, array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_api_keys_on_key", unique: true
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id", "product_id"], name: "index_cart_items_on_cart_id_and_product_id", unique: true
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["product_id"], name: "index_cart_items_on_product_id"
  end

  create_table "carts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_carts_on_user_id", unique: true
  end

  create_table "discount_products", force: :cascade do |t|
    t.bigint "discount_id", null: false
    t.bigint "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discount_id"], name: "index_discount_products_on_discount_id"
    t.index ["product_id"], name: "index_discount_products_on_product_id"
  end

  create_table "discounts", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.string "kind", default: "fixed", null: false
    t.decimal "value", precision: 10, scale: 2, null: false
    t.string "code", null: false
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.integer "max_uses", null: false
    t.integer "uses_count", default: 0, null: false
    t.text "uses_used", default: [], array: true
    t.integer "max_uses_per_user", default: 0, null: false
    t.decimal "min_order_value", precision: 10, scale: 2
    t.decimal "max_order_value", precision: 10, scale: 2
    t.bigint "shop_id", null: false
    t.boolean "is_active", default: true, null: false
    t.string "applies_to", default: "all", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id", "code"], name: "index_discounts_on_shop_id_and_code", unique: true
    t.index ["shop_id"], name: "index_discounts_on_shop_id"
  end

  create_table "inventories", force: :cascade do |t|
    t.string "location", default: "unknown"
    t.integer "stock", default: 0, null: false
    t.integer "product_id", null: false
    t.integer "shop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id", "product_id"], name: "index_inventories_on_shop_id_and_product_id", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.string "thumbnail", null: false
    t.text "description"
    t.decimal "price", null: false
    t.integer "quantity", null: false
    t.string "category", null: false
    t.bigint "shop_id", null: false
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.decimal "average_rating", precision: 2, scale: 1, default: "4.5", null: false
    t.jsonb "variations", default: []
    t.boolean "is_draft", default: true, null: false
    t.boolean "is_published", default: false, null: false
    t.index ["is_draft"], name: "index_products_on_is_draft"
    t.index ["is_published"], name: "index_products_on_is_published"
    t.index ["shop_id"], name: "index_products_on_shop_id"
    t.index ["slug"], name: "index_products_on_slug", unique: true
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "inventory_id", null: false
    t.bigint "cart_id", null: false
    t.integer "quantity"
    t.datetime "expired_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_reservations_on_cart_id"
    t.index ["inventory_id", "cart_id"], name: "index_reservations_on_inventory_id_and_cart_id", unique: true
    t.index ["inventory_id"], name: "index_reservations_on_inventory_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name", null: false
    t.string "email"
    t.string "password_digest", null: false
    t.string "status", default: "inactive"
    t.boolean "verify", default: false
    t.text "roles", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_shops_on_email", unique: true
  end

  create_table "tokens", force: :cascade do |t|
    t.string "public_key", null: false
    t.string "private_key", null: false
    t.text "refresh_tokens_used", default: [], array: true
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "refresh_token"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "products"
  add_foreign_key "discount_products", "discounts"
  add_foreign_key "discount_products", "products"
  add_foreign_key "discounts", "shops"
  add_foreign_key "products", "shops"
  add_foreign_key "reservations", "carts"
  add_foreign_key "reservations", "inventories"
end
