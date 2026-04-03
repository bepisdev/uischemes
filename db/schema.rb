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

ActiveRecord::Schema[8.1].define(version: 2026_04_03_100016) do
  create_table "palette_tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "palette_id", null: false
    t.integer "tag_id", null: false
    t.datetime "updated_at", null: false
    t.index ["palette_id", "tag_id"], name: "index_palette_tags_on_palette_id_and_tag_id", unique: true
    t.index ["palette_id"], name: "index_palette_tags_on_palette_id"
    t.index ["tag_id"], name: "index_palette_tags_on_tag_id"
  end

  create_table "palettes", force: :cascade do |t|
    t.string "accent_hex", limit: 7, null: false
    t.string "background_hex", limit: 7, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.string "primary_hex", limit: 7, null: false
    t.string "secondary_hex", limit: 7, null: false
    t.string "surface_hex", limit: 7, null: false
    t.string "text_hex", limit: 7, null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_palettes_on_name", unique: true
  end

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
    t.index ["slug"], name: "index_tags_on_slug", unique: true
  end

  add_foreign_key "palette_tags", "palettes"
  add_foreign_key "palette_tags", "tags"
end
