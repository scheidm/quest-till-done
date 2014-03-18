class AddGithubAccessTokenForUsers < ActiveRecord::Migration
  def change
    add_column(:users, "github_access_token", :text)
    add_column(:users, "github_username", :text)
  end
end
