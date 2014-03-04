class AddQuestImportanceColumn < ActiveRecord::Migration
  def change
	add_column :quests, :importance, :boolean, default: false
  end
end
