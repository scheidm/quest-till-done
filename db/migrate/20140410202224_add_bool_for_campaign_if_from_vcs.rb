class AddBoolForCampaignIfFromVcs < ActiveRecord::Migration
  def change
    add_column :quests, :vcs, :boolean
  end
end
