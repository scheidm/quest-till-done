class LegacyTagsRemoval < ActiveRecord::Migration
  def up
    drop_table :tags
  end
  def down
    create_table "tags", force: true do |t|
      t.string "name"
    end
  end
end
