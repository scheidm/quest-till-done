
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

  # destroy avatar
  def destroy_avatar

  end

  def show
    login
    list_projects
    list_branches 'scheidm', 'quest-till-done'
    list_issues 'scheidm', 'quest-till-done', nil, nil
    list_commits 'scheidm', 'quest-till-done', nil, nil
  end


  def github_list
    login
    list_projects
    @projects = GithubAccount.where(user_id: current_user)
  end

  def github_project_import
    login
    initial_import params[:github_user], params[:repo_name]
  end

  def github_project_del
    login
    del_project params[:github_user], params[:repo_name]
  end


end
