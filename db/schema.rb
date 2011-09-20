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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110920071334) do

  create_table "browsers", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations_monitor_profiles", :id => false, :force => true do |t|
    t.integer "location_id",        :null => false
    t.integer "monitor_profile_id", :null => false
  end

  create_table "monitor_profiles", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "frequency"
    t.integer  "network_connection_id"
    t.integer  "user_id"
    t.integer  "browser_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "monitor_tasks", :force => true do |t|
    t.datetime "next_scheduled_at"
    t.integer  "location_id"
    t.integer  "monitor_profile_id"
    t.integer  "lock_version",       :default => 0,     :null => false
    t.boolean  "realtime",           :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "network_connections", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
