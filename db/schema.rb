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

ActiveRecord::Schema.define(version: 2020_07_24_232117) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "external_id", null: false
    t.string "display_name"
    t.string "account_type", null: false
    t.integer "balance_in_cents", null: false
    t.datetime "created_at", null: false
    t.index ["external_id"], name: "index_accounts_on_external_id", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.string "external_id", null: false
    t.string "external_account_id", null: false
    t.string "status", null: false
    t.string "raw_text"
    t.string "description", null: false
    t.string "message"
    t.integer "hold_amount_in_cents"
    t.string "hold_foreign_currency"
    t.integer "hold_foreign_amount_in_base_units"
    t.integer "amount_in_cents", null: false
    t.string "foreign_currency"
    t.integer "foreign_amount_in_base_units"
    t.integer "round_up_amount_in_cents"
    t.integer "round_up_boost_in_cents"
    t.datetime "settled_at"
    t.datetime "created_at", null: false
    t.string "cash_back_description"
    t.integer "cash_back_amount_in_cents"
    t.index ["external_account_id"], name: "index_transactions_on_external_account_id"
    t.index ["external_id"], name: "index_transactions_on_external_id", unique: true
  end

  create_table "webhooks", force: :cascade do |t|
    t.string "external_id", null: false
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.string "secret_key"
    t.index ["external_id"], name: "index_webhooks_on_external_id", unique: true
  end

end
