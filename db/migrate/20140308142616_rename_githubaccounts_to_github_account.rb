class RenameGithubaccountsToGithubAccount < ActiveRecord::Migration
  def change
    rename_table :githubaccounts, :github_accounts
  end
end
