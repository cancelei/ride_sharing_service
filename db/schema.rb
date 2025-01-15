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

ActiveRecord::Schema[8.0].define(version: 2025_01_14_162139) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "cab_associations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "driver_profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "cab_association_id", null: false
    t.string "license_number", null: false
    t.integer "status", default: 0
    t.decimal "rating", precision: 3, scale: 2
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cab_association_id"], name: "index_driver_profiles_on_cab_association_id"
    t.index ["latitude", "longitude"], name: "index_driver_profiles_on_latitude_and_longitude"
    t.index ["license_number"], name: "index_driver_profiles_on_license_number", unique: true
    t.index ["status"], name: "index_driver_profiles_on_status"
    t.index ["user_id"], name: "index_driver_profiles_on_user_id"
  end

  create_table "passenger_profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "full_name"
    t.string "phone_number"
    t.decimal "rating", precision: 3, scale: 2
    t.jsonb "preferences", default: {}
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_passenger_profiles_on_active"
    t.index ["phone_number"], name: "index_passenger_profiles_on_phone_number", unique: true
    t.index ["user_id"], name: "index_passenger_profiles_on_user_id"
  end

  create_table "passenger_profiles_rides", id: false, force: :cascade do |t|
    t.bigint "ride_id", null: false
    t.bigint "passenger_profile_id", null: false
    t.index ["passenger_profile_id", "ride_id"], name: "index_passengers_rides"
    t.index ["ride_id", "passenger_profile_id"], name: "index_rides_passengers", unique: true
  end

  create_table "rides", force: :cascade do |t|
    t.string "status", default: "pending", null: false
    t.string "ride_code", null: false
    t.decimal "total_amount", precision: 10, scale: 2
    t.integer "ride_type", default: 0
    t.decimal "pickup_latitude", precision: 10, scale: 6
    t.decimal "pickup_longitude", precision: 10, scale: 6
    t.decimal "dropoff_latitude", precision: 10, scale: 6
    t.decimal "dropoff_longitude", precision: 10, scale: 6
    t.string "pickup_address"
    t.string "dropoff_address"
    t.bigint "leader_id", null: false
    t.bigint "driver_profile_id"
    t.datetime "scheduled_at"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_profile_id"], name: "index_rides_on_driver_profile_id"
    t.index ["dropoff_latitude", "dropoff_longitude"], name: "index_rides_on_dropoff_latitude_and_dropoff_longitude"
    t.index ["leader_id"], name: "index_rides_on_leader_id"
    t.index ["pickup_latitude", "pickup_longitude"], name: "index_rides_on_pickup_latitude_and_pickup_longitude"
    t.index ["ride_code"], name: "index_rides_on_ride_code", unique: true
    t.index ["status"], name: "index_rides_on_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "phone", null: false
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "notification_preferences", default: {"email"=>true, "telegram"=>false, "whatsapp"=>false}, null: false
    t.string "whatsapp_number"
    t.string "telegram_username"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["notification_preferences"], name: "index_users_on_notification_preferences", using: :gin
    t.index ["phone"], name: "index_users_on_phone", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "driver_profiles", "cab_associations"
  add_foreign_key "driver_profiles", "users"
  add_foreign_key "passenger_profiles", "users"
  add_foreign_key "rides", "driver_profiles"
  add_foreign_key "rides", "passenger_profiles", column: "leader_id"
end
