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

ActiveRecord::Schema.define(version: 20140312133308) do

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "encounters", force: true do |t|
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "friends", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "github_accounts", force: true do |t|
    t.integer  "user_id"
    t.string   "github_user"
    t.string   "project_name"
    t.string   "url"
    t.boolean  "imported"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quests", force: true do |t|
    t.string   "name",                           null: false
    t.string   "status"
    t.string   "priority"
    t.text     "description"
    t.integer  "estimated_cost"
    t.integer  "current_cost"
    t.integer  "parent_id"
    t.integer  "campaign_id"
    t.date     "deadline"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "importance",     default: false
    t.string   "type"
  end

  create_table "records", force: true do |t|
    t.string   "type"
    t.text     "description",        null: false
    t.string   "url"
    t.integer  "encounter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quest_id"
    t.text     "quote"
    t.text     "github_username"
    t.text     "github_projectname"
    t.text     "sha"
    t.integer  "user_id"
  end

  create_table "rounds", force: true do |t|
    t.string   "type"
    t.integer  "event_id"
    t.string   "event_description"
    t.integer  "encounter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "campaign_id"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "skill_points", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "level"
    t.integer  "exp"
    t.integer  "user_id_id"
  end

  create_table "skills", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "achievements"
    t.string   "description"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true

  create_table "tags", force: true do |t|
    t.string "name"
  end

  create_table "timers", force: true do |t|
    t.integer  "user_id"
    t.integer  "setting_time"
    t.integer  "current_time"
    t.boolean  "enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "state"
    t.string   "mode"
  end

  create_table "user_configs", force: true do |t|
    t.integer  "user_id"
    t.string   "timezone_name"
    t.boolean  "auto_timer"
    t.integer  "utc_time_offset"
    t.integer  "encounter_duration"
    t.integer  "short_break_duration"
    t.integer  "extended_break_duration"
    t.integer  "encounter_extend_duration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username",               default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "active_quest_id"
    t.integer  "notification_level",     default: 1,  null: false
    t.integer  "adventure_level"
    t.integer  "recent_level"
    t.text     "achievements"
    t.integer  "level"
    t.integer  "exp"
    t.integer  "group_id"
    t.string   "github_token"
    t.text     "github_access_token"
    t.text     "github_username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "users_groups", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "group_id"
  end

end
