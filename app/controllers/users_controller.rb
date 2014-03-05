
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
    list_issues 'scheidm', 'quest-till-done'
    commits 'scheidm', 'quest-till-done'
    initial_import 'scheidm', 'quest-till-done'
  end


  def github_list
    login
    list_projects
    @projects = Githubaccounts.where(user_id: current_user)
  end

  def github_project_import
    initial_import params[:github_user], params[:repo_name]
  end

  def github_project_del

  end


end
