class AddBackGithubInfoForRecords < ActiveRecord::Migration
  def change
    add_column :records, :github_user, :string
    add_column :records, :project_name, :string
  end
end
