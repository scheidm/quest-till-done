class CreateGroupinvitations < ActiveRecord::Migration
  def change
    create_table :groupinvitations do |t|
      t.integer   "group_id"
      t.integer   "user_id"
      t.boolean   "accept"
      t.datetime  "created_at"
      t.boolean   "expired"
    end
  end
end
