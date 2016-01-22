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

ActiveRecord::Schema.define(version: 20160121190921) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins_groups", id: false, force: true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  create_table "colors", force: true do |t|
    t.string   "type"
    t.integer  "related_id"
    t.string   "color_hex"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conversations", force: true do |t|
    t.string   "subject",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

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

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "encounters", force: true do |t|
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "break_flag"
  end

  create_table "friends", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "github_repos", force: true do |t|
    t.integer  "group_id"
    t.integer  "assigned_user"
    t.string   "github_user"
    t.string   "project_name"
    t.string   "url"
    t.boolean  "imported"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "lastest_commit"
    t.datetime "lastest_issue"
    t.integer  "campaign_id"
  end

  create_table "groupinvitations", force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.boolean  "accept"
    t.datetime "created_at"
    t.boolean  "expired"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "groups_users", id: false, force: true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  create_table "invitation_status_tables", force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.boolean  "accept"
    t.datetime "created_at"
    t.boolean  "expired"
  end

  create_table "notifications", force: true do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              default: ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                default: false
    t.datetime "updated_at",                           null: false
    t.datetime "created_at",                           null: false
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "notification_code"
    t.string   "attachment"
    t.boolean  "global",               default: false
    t.datetime "expires"
  end

  add_index "notifications", ["conversation_id"], name: "index_notifications_on_conversation_id", using: :btree

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
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "importance",     default: false
    t.string   "type"
    t.string   "slug"
    t.integer  "issue_no"
    t.boolean  "vcs"
    t.integer  "user_id"
  end

  create_table "receipts", force: true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                            null: false
    t.boolean  "is_read",                    default: false
    t.boolean  "trashed",                    default: false
    t.boolean  "deleted",                    default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "receipts", ["notification_id"], name: "index_receipts_on_notification_id", using: :btree

  create_table "records", force: true do |t|
    t.string   "type"
    t.text     "description",       null: false
    t.text     "url"
    t.integer  "encounter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quest_id"
    t.text     "quote"
    t.text     "sha"
    t.integer  "group_id"
    t.string   "slug"
    t.string   "code_file_name"
    t.string   "code_content_type"
    t.integer  "code_file_size"
    t.datetime "code_updated_at"
    t.string   "github_user"
    t.string   "project_name"
  end

  create_table "rounds", force: true do |t|
    t.string   "type"
    t.integer  "event_id"
    t.string   "event_description"
    t.integer  "user_id"
    t.integer  "encounter_id"
    t.integer  "campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

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

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

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
    t.datetime "last_notification"
    t.integer  "notification_count"
    t.integer  "dislayed_gritter_notifications"
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

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_groups", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "group_id"
  end

  add_foreign_key "notifications", "conversations", name: "notifications_on_conversation_id"

  add_foreign_key "receipts", "notifications", name: "receipts_on_notification_id"

end
