class GithubWorker
  include Sidekiq::Worker
  include GithubHelper
  sidekiq_options queue: "high"
  sidekiq_options retry: false

  def perform(user)
    github_update_all_projects(user)
  end

end