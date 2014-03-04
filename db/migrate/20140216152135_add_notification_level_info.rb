class AddNotificationLevelInfo < ActiveRecord::Migration
  def up
    add_column :users, :notification_level, :integer, null: false, default: 1

    #add_column :users_groups, :notification_level, :integer, null: false, default: 3
    #add_column :users_projects, :notification_level, :integer, null: false, default: 3

  end

  def down
    remove_column(users, :notification_level)
  end
end
