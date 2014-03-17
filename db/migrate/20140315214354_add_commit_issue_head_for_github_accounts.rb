class AddCommitIssueHeadForGithubAccounts < ActiveRecord::Migration
  def change
    add_column :github_repos, 'lastest_commit', :text
    add_column :github_repos, 'lastest_issue', :datetime
  end
end
