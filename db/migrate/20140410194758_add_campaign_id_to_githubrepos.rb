class AddCampaignIdToGithubrepos < ActiveRecord::Migration
  def change
    add_column :github_repos, :campaign_id, :integer
  end
end
