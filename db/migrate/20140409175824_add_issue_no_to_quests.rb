class AddIssueNoToQuests < ActiveRecord::Migration
  def change
    add_column :quests, :issue_no, :integer
  end
end
