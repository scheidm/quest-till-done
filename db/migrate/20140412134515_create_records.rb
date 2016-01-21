class CreateRecords < ActiveRecord::Migration
  def change
    create_table "records", force: true do |t|
      t.string   "type"
      t.text     "description",        null: false
      t.text     "url"
      t.integer  "encounter_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "quest_id"
      t.text     "quote"
      t.text     "github_username"
      t.text     "github_projectname"
      t.text     "sha"
      t.integer  "group_id"
      t.string   "slug"
    end

    add_index "records", ["slug"], name: "index_records_on_slug", using: :btree
  end
end
