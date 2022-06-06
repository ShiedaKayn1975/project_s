# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_05_30_160700) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_logs", force: :cascade do |t|
    t.string "state"
    t.string "action_code"
    t.string "action_label"
    t.jsonb "action_data"
    t.jsonb "context"
    t.bigint "actor_id"
    t.string "actionable_type"
    t.bigint "actionable_id"
    t.jsonb "object_before"
    t.jsonb "object_after"
    t.jsonb "error"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["actionable_type"], name: "index_action_logs_on_actionable_type"
    t.index ["actor_id"], name: "index_action_logs_on_actor_id"
  end

  create_table "import_logs", force: :cascade do |t|
    t.string "status"
    t.string "resource"
    t.jsonb "request"
    t.jsonb "response"
    t.bigint "importer_id"
    t.bigint "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_import_logs_on_company_id"
    t.index ["importer_id"], name: "index_import_logs_on_importer_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "title"
    t.bigint "price"
    t.bigint "compare_price"
    t.bigint "creator_id"
    t.boolean "active"
    t.integer "index"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "kind"
    t.string "commitions", array: true
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "user_id"
    t.string "method"
    t.string "message"
    t.bigint "amount"
    t.string "reference"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "password_digest"
    t.string "status"
    t.boolean "admin"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "balance"
    t.string "code"
  end

  create_table "variants", force: :cascade do |t|
    t.bigint "product_id"
    t.string "info"
    t.string "status"
    t.string "account_uid"
    t.bigint "owner"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "import_log_id"
    t.datetime "buyed_at"
  end

end
