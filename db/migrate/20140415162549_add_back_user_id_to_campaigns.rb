class AddBackUserIdToCampaigns < ActiveRecord::Migration
  def change
    add_column :quests, :user_id, :integer
    add_column :records, :user_id, :integer
  end
end
