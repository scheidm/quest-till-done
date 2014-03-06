class CreateGithubaccounts < ActiveRecord::Migration
  def change
    create_table :githubaccounts do |t|
      t.belongs_to :user
      t.string :github_user
      t.string :project_name
      t.string :url
      t.boolean :imported
      t.timestamps
    end
  end
end
