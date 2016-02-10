class CreateRounds < ActiveRecord::Migration
  def change
    create_table "rounds", :id => false do |t|
      t.integer :id, :limit => 8
      t.string   "type"
      t.integer  "event_id"
      t.string   "event_description"
      t.integer  "user_id"
      t.integer  "encounter_id"
      t.integer  "campaign_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
