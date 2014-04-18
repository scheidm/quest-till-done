class AddUserToQuest < ActiveRecord::Migration
  def change
    add_column :quests, :user_id, :integer
  end
end
