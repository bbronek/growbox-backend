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

ActiveRecord::Schema[7.0].define(version: 2023_04_12_010142) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "device_logs", force: :cascade do |t|
    t.float "temp"
    t.float "soil_hum"
    t.float "air_hum"
    t.float "light"
    t.bigint "device_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_device_logs_on_device_id"
  end

  create_table "devices", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "login"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "token_version"
  end

  add_foreign_key "device_logs", "devices"
  add_foreign_key "devices", "users"
end
