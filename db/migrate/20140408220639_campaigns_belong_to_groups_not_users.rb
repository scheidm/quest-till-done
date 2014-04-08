class CampaignsBelongToGroupsNotUsers < ActiveRecord::Migration
  def change
    rename_column :quests, :user_id, :group_id
  end
end
