class GithubInit
  include Sidekiq::Worker
  include GithubHelper

  def perform(user, github_user, github_project)
    @user = User.find(user)
    login(@user)
    initial_import github_user, github_project , nil
  end
end