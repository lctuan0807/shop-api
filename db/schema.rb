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

ActiveRecord::Schema[7.2].define(version: 2026_05_28_045639) do
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

  add_foreign_key "products", "shops"
end
