class GithubWorker
  include Sidekiq::Worker
  include GithubHelper
  sidekiq_options retry: false

  def perform(actionname, user_id)
    current_user = User.find(user_id)
    login(current_user)
    current_user.g
    GithubRepo.find(group: current_user.wrapper_group).where(imported: true).each do |repo|
      update_project current_user, repo.github_user, repo.project_name
    end
  end

end