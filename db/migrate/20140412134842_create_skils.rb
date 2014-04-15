class CreateSkils < ActiveRecord::Migration
  def change
    create_table "skill_points", force: true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "level"
      t.integer  "exp"
      t.integer  "user_id_id"
    end

    create_table "skills", force: true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "achievements"
      t.string   "description"
    end
  end
end
