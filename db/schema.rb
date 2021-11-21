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

ActiveRecord::Schema.define(version: 2021_11_21_214122) do

  create_table "currency_codes", force: :cascade do |t|
    t.string "code"
    t.datetime "rate_last_update"
    t.datetime "rate_next_update"
    t.datetime "rate_last_update_request"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "currency_rates", force: :cascade do |t|
    t.integer "code_from_id", null: false
    t.integer "code_to_id", null: false
    t.float "rate"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code_from_id"], name: "index_currency_rates_on_code_from_id"
    t.index ["code_to_id"], name: "index_currency_rates_on_code_to_id"
  end

  add_foreign_key "currency_rates", "currency_codes", column: "code_from_id"
  add_foreign_key "currency_rates", "currency_codes", column: "code_to_id"
end
