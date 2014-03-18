class AddShaForCommitsAndIssues < ActiveRecord::Migration
  def change
    add_column(:records, "sha", :text)
  end
end
