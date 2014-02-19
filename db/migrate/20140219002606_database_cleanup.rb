class DatabaseCleanup < ActiveRecord::Migration
  def up
    drop_table :tags
    drop_table :skill_points
    create_table skill_points do |t|
      t.timestamps
      t.integer  :level
      t.integer  :exp
      t.belongs_to :user_id
    end
  end
  def down
    drop_table :skill_points
    create_table "skill_points", force: true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "level"
      t.integer  "exp"
    end
    create_table "tags", force: true do |t|
      t.string "name"
    end
  end
end
