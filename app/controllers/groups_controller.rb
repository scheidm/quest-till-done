# Controller for the group page
class GroupsController < ApplicationController
  layout "profile"

  # Display a list of all groups for the current user
  def index
    @user_groups = current_user.users_groups.page(params[:page]).per(20)
  end

  # Display the group page for the specified group, presuming the user has
  # access rights granted to them.
  def show
    @group ||= Group.find_by_path(params[:id])
  end
end
