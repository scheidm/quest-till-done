class AddGithubInfoForRecords < ActiveRecord::Migration
  def change
    add_column(:records, "github_username", :text)
    add_column(:records, "github_projectname", :text)
  end
end
