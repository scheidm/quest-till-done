class GithubWorker
  include Sidekiq::Worker
  include GithubHelper
  # sidekiq_options retry: false

  def perform(user)
    current_user = User.find(user)
    login
    github_update_all_projects(user)
  end

end