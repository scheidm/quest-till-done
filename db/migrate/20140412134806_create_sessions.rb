class CreateSessions < ActiveRecord::Migration
  def change
    create_table "sessions", force: true do |t|
      t.string   "session_id", null: false
      t.text     "data"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
    add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end
end
