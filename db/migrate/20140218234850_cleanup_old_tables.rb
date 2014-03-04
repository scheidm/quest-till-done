class CleanupOldTables < ActiveRecord::Migration
  def up
    drop_table :admins
  end
  def down
    create_table "admins", force: true do |t|
      t.string   "username",           default: "", null: false
      t.string   "email",              default: "", null: false
      t.string   "encrypted_password", default: "", null: false
      t.integer  "sign_in_count",      default: 0
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.integer  "failed_attempts",    default: 0
      t.string   "unlock_token"
      t.datetime "locked_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
