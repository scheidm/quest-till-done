# Controller for the group page
class GroupsController < ApplicationController
  power :crud => :campaigns

  # Display a list of all groups for the current user
  def index
    @member_groups = @user.groups_where_member
    @admin_groups = @user.groups_where_admin
  end

  # Display the group page for the specified group, presuming the user has
  # access rights granted to them.
  def show
    @group = Group.find_by_path(params[:id])
    redirect_to groups_path unless current_power.group? @group
  end

  def leave
    @group = Group.find_by_path(params[:id])
    @group.leave @user
  end

  private

  def group
    @group ||= Group.find_by_path(params[:id])
  end
end
