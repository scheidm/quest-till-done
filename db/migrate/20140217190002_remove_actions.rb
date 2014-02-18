class RemoveActions < ActiveRecord::Migration
  def up
    drop_table :actions
  end

  def down
    create_table "actions", force: true do |t|
      t.string   "name"
      t.string   "status"
      t.text     "description"
      t.integer  "estimated_cost"
      t.integer  "current_cost"
      t.date     "deadline"
      t.string   "priority"
      t.integer  "parent_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
