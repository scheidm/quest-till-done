class AddGroupAndAdmins < ActiveRecord::Migration
  def up
    drop_table :users_groups
    create_table :admins_groups, id: false do |t|
      t.belongs_to :group
      t.belongs_to :user
    end
    create_table :groups_users, id: false do |t|
      t.belongs_to :group
      t.belongs_to :user
    end
  end
  def down
    drop_table :admins_groups
    drop_table :groups_users
    create_table "users_groups", id: false, force: true do |t|
      t.integer "user_id"
      t.integer "group_id"
    end
  end
end
