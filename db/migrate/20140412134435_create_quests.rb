class CreateQuests < ActiveRecord::Migration
  def change
    create_table "quests", :id => false do |t|
      t.integer :id, :limit => 8
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
  end
end
