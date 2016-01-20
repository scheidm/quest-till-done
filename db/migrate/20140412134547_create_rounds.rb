class CreateRounds < ActiveRecord::Migration
  def change
    create_table "rounds", force: true do |t|
      t.string   "type"
      t.integer  "event_id"
      t.string   "event_description"
      t.integer  "encounter_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "campaign_id"
      t.integer   "group_id"
    end
  end
end
