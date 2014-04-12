class CreateEncounters < ActiveRecord::Migration
  def change
    create_table "encounters", force: true do |t|
      t.datetime "end_time"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "user_id"
    end
  end
end
