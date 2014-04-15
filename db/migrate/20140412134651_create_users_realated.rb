class CreateUsersRealated < ActiveRecord::Migration
  def change
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

    add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
    add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

    create_table "users_groups", id: false, force: true do |t|
      t.integer "user_id"
      t.integer "group_id"
    end
  end
end
