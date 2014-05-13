class AddNotificationFieldsToUserConfigs < ActiveRecord::Migration
  def change
    add_column :user_configs, :last_notification, :datetime
    add_column :user_configs, :notification_count, :integer
    add_column :user_configs, :dislayed_gritter_notifications, :integer
  end
end
