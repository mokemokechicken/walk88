# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20130625095200) do

  create_table "locations", force: true do |t|
    t.integer "number"
    t.string  "name"
    t.string  "address"
    t.float   "lat"
    t.float   "lon"
    t.float   "next_distance"
    t.float   "total_distance"
  end

  add_index "locations", ["number"], name: "index_locations_on_number", unique: true

  create_table "user_records", force: true do |t|
    t.integer  "user_id"
    t.date     "day"
    t.integer  "steps"
    t.float    "distance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_records", ["user_id", "day"], name: "index_user_records_on_user_id_and_day", unique: true

  create_table "user_settings", force: true do |t|
    t.integer  "user_id"
    t.integer  "step_dist"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fitbit_user_id"
    t.string   "fitbit_token"
    t.string   "fitbit_secret"
  end

  create_table "user_statuses", force: true do |t|
    t.integer  "user_id"
    t.integer  "total_step",       default: 0
    t.float    "total_distance",   default: 0.0
    t.float    "lat"
    t.float    "lon"
    t.integer  "location_id"
    t.integer  "next_location_id"
    t.float    "next_distance"
    t.date     "last_walk_day"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_statuses", ["user_id"], name: "index_user_statuses_on_user_id", unique: true

  create_table "users", force: true do |t|
    t.string   "uid"
    t.string   "nickname"
    t.string   "provider"
    t.string   "image"
    t.string   "token"
    t.integer  "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["uid"], name: "index_users_on_uid", unique: true

end
