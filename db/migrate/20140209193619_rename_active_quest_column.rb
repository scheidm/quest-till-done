class RenameActiveQuestColumn < ActiveRecord::Migration
  def change
  	rename_column :users, :active_quest, :active_quest_id
  end
end
