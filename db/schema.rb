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

ActiveRecord::Schema[7.2].define(version: 2025_11_10_162501) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "preset_items", force: :cascade do |t|
    t.bigint "preset_id", null: false
    t.string "system"
    t.string "issue_key"
    t.text "description"
    t.integer "minutes_spent"
    t.string "tempo_work_kind"
    t.string "tempo_cs_action"
    t.string "tempo_cs_is"
    t.string "yaga_workspace"
    t.string "yaga_work_kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["preset_id"], name: "index_preset_items_on_preset_id"
  end

  create_table "presets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.integer "weekday"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_presets_on_user_id"
  end

  create_table "template_cards", force: :cascade do |t|
    t.bigint "template_category_id", null: false
    t.string "system"
    t.string "issue_key"
    t.text "description"
    t.integer "minutes_spent"
    t.string "tempo_work_kind"
    t.string "tempo_cs_action"
    t.string "tempo_cs_is"
    t.string "yaga_workspace"
    t.string "yaga_work_kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["template_category_id"], name: "index_template_cards_on_template_category_id"
  end

  create_table "template_categories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.boolean "collapsed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_template_categories_on_user_id"
  end

  create_table "tempo_attribute_preferences", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "category", null: false
    t.jsonb "visible_ids"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "category"], name: "index_tempo_attribute_prefs_on_user_and_category", unique: true
    t.index ["user_id"], name: "index_tempo_attribute_preferences_on_user_id"
  end

  create_table "tempo_work_attributes", force: :cascade do |t|
    t.integer "external_id", null: false
    t.string "name"
    t.string "key"
    t.string "value"
    t.string "category"
    t.datetime "synced_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_tempo_work_attributes_on_external_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tempo_login"
    t.text "tempo_password_ciphertext"
    t.jsonb "tempo_defaults", default: {}, null: false
    t.string "yaga_login"
    t.text "yaga_password_ciphertext"
    t.jsonb "yaga_defaults", default: {}, null: false
    t.string "otrs_login"
    t.text "otrs_password_ciphertext"
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "work_items", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "date"
    t.integer "minutes_spent"
    t.string "project_key"
    t.string "issue_key"
    t.text "description"
    t.integer "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "system", default: "tempo", null: false
    t.string "tempo_work_kind"
    t.string "tempo_cs_action"
    t.string "tempo_cs_is"
    t.string "yaga_workspace"
    t.string "yaga_work_kind"
    t.string "title"
    t.string "source"
    t.index ["user_id"], name: "index_work_items_on_user_id"
  end

  add_foreign_key "preset_items", "presets"
  add_foreign_key "presets", "users"
  add_foreign_key "template_cards", "template_categories"
  add_foreign_key "template_categories", "users"
  add_foreign_key "tempo_attribute_preferences", "users"
  add_foreign_key "work_items", "users"
end
