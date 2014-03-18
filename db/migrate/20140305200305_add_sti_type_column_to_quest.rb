class AddStiTypeColumnToQuest < ActiveRecord::Migration
  def change
    add_column :quests, :type, :string
  end
end
