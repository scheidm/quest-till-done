class CreateGithubRepos < ActiveRecord::Migration
  def change
    create_table "github_repos", force: true do |t|
      t.integer  "group_id"
      t.integer  "assigned_user"
      t.string   "github_user"
      t.string   "project_name"
      t.string   "url"
      t.boolean  "imported"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "lastest_commit"
      t.datetime "lastest_issue"
      t.integer  "campaign_id"
    end
  end
end
