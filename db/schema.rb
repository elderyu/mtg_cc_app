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

ActiveRecord::Schema.define(version: 2019_01_15_112705) do

  create_table "cards", force: :cascade do |t|
    t.string "name"
    t.string "image_url_normal"
    t.string "image_url_small"
    t.string "cmc"
    t.string "type_line"
    t.string "oracle_text"
    t.string "power"
    t.string "toughness"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mana_cost", default: "--- []\n"
    t.string "card_id"
  end

  create_table "collected_cards", force: :cascade do |t|
    t.integer "user_id"
    t.integer "count"
    t.integer "card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
