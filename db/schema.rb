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

ActiveRecord::Schema.define(version: 2020_05_05_160313) do

  create_table "tmpusers", force: :cascade do |t|
    t.string "email", null: false
    t.string "uuid", null: false
    t.datetime "expire_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "to_buys", force: :cascade do |t|
    t.string "name"
    t.integer "count"
    t.text "special_option"
    t.boolean "is_done"
    t.integer "who_wants_id"
    t.integer "who_did_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["who_did_id"], name: "index_to_buys_on_who_did_id"
    t.index ["who_wants_id"], name: "index_to_buys_on_who_wants_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
  end

  add_foreign_key "to_buys", "users", column: "who_did_id"
  add_foreign_key "to_buys", "users", column: "who_wants_id"
end
