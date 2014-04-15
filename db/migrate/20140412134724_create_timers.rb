class CreateTimers < ActiveRecord::Migration
  def change
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
  end
end
