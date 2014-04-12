class CreateFriends < ActiveRecord::Migration
  def change
    create_table "friends", force: true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
