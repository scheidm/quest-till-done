
class UsersController < ApplicationController

  include RoundHelper
  include GithubHelper

  def index
    @user = current_user
  end
  def getFriends
    @friends = current_user.getFriends
  end
  def getGroups
    @groups = current_user.getGroups
  end
  # define avatar by default value
  # @return [Binary] image file
  def show_avatar

  end

  def settings
   @config=UserConfig.where('user_id = (?)',@user.id).first
  end

  # destroy avatar
  def destroy_avatar

  end

  def show
    #login
    #list_projects
    #list_branches 'scheidm', 'quest-till-done'
    #list_issues 'scheidm', 'quest-till-done', nil, nil
    #list_commits 'scheidm', 'quest-till-done', nil, nil
    if current_user.github_access_token.nil?
      github_authorize
    else
      github_list
    end

  end

  def github_authorize
    authorize
  end

  def github_callback
    callback
  end

  def github_list
    login
    list_projects
    @projects = GithubRepo.where(user_id: current_user)
  end

  def github_project_import
    login
    initial_import params[:github_user], params[:repo_name]
  end

  def github_project_del
    login
    del_project params[:github_user], params[:repo_name]
  end

  def github_update
    login
    update_project params[:github_user], params[:repo_name]
  end


end
