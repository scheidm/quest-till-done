class CreateGithubRepo < ActiveRecord::Migration
  def change
    create_table :github_repos do |t|
      t.belongs_to :user
      t.string :github_user
      t.string :project_name
      t.string :url
      t.boolean :imported
      t.timestamps
    end
  end
end
