class CreateQuests < ActiveRecord::Migration
  def change
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
    end

    add_index "quests", ["slug"], name: "index_quests_on_slug", using: :btree
  end
end
