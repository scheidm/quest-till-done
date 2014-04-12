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
    @group = Group.find(params[:id])
    redirect_to groups_path unless current_power.group? @group
  end

  def leave
    @group = Group.find(params[:id])
    @group.leave
  end

  def kick
    @group = Group.find(params[:id])
    if @group.admins.includes? @user
      @target = User.find( params[:user_id] )
      if @group.admins.includes? @target
        #NOTIFICATION NEEDED
      else
        @group.users.delete User.find( params[:user_id] )
      end
    end
  end

  def join
    #NOTIFICATION NEEDED
  end

  def invite_user
    #NOTIFICATION NEEDED
  end

  def accept_user
    #NOTIFICATION NEEDED
  end

  private

  def group
    @group ||= Group.find(params[:id])
  end
end
