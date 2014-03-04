
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
    import 'scheidm', 'quest-till-done'
  end




end
