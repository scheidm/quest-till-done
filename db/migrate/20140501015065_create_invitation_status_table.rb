class CreateInvitationStatusTable < ActiveRecord::Migration
  def change
    create_table :invitation_status do |t|
      t.integer   "group_id"
      t.integer   "user_id"
      t.boolean   "accept"
      t.datetime  "created_at"
      t.boolean   "expired"
    end
  end
end
