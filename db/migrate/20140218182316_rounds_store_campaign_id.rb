class RoundsStoreCampaignId < ActiveRecord::Migration
  def change
    add_column :rounds, :campaign_id, :integer
  end
end
