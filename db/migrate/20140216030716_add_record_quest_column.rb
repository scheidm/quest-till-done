class AddRecordQuestColumn < ActiveRecord::Migration
  def up
      add_column(:records, "quest_id",:integer, :after => "encounter_id")
  end

  def down
      remove_column(:records, :quest)
  end
end
