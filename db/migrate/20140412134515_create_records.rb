class CreateRecords < ActiveRecord::Migration
  def change
    create_table "records", :id => false do |t|
      t.integer :id, :limit => 8
      t.string   "type"
      t.text     "description",        null: false
      t.text     "url"
      t.integer  "encounter_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "quest_id"
      t.text     "quote"
      t.text     "sha"
      t.string   "code_file_name"
      t.string   "code_content_type"
      t.integer  "code_file_size"
      t.datetime "code_updated_at"
      t.integer  "group_id"
      t.string   "slug"
    end

  end
end
