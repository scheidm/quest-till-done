class RemoveGithubInfoForRecords < ActiveRecord::Migration
  def change
    remove_column :records, :github_projectname
    remove_column :records, :github_username
  end
end
