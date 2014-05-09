class GithubWorker
  include Sidekiq::Worker
  include GithubHelper
  sidekiq_options queue: "high"
  sidekiq_options retry: false

  github_update_all_projects
end