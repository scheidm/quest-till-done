# Controller for the group page
class GroupsController < ApplicationController
  power :crud => :groups

  # Will display a list of all groups for the current user
  def index
    @member_groups = @user.groups_where_member
    @admin_groups = @user.groups_where_admin
  end

  # Will display the group page for the specified group, presuming the user has
  # access rights granted to them.
  def show
    @group = Group.find(params[:id])
  redirect_to groups_path, :flash => { :warning =>"Permission Denied"}\
    unless current_power.group? @group
  end

  # Will restrict parameters to those formally specified
  def group_params
    params.require(:group).permit(:id, :name)
  end

  # Will allow the user to create a new group
  def new
    @group = Group.new()
  end

  # Will take the specified parameters and save a new group
  def create
    @group = Group.new(group_params)
    respond_to do |format|
      if @group.save
        @group.admins.push @user
        @group.users.push @user
        format.html { redirect_to group_path(@group), notice: 'Group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @quest.campaign }
      else
        format.html { render action: 'new'}
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # Will remove the user from the group specified
  # @param id [Integer] The id of the group
  def leave
    @group = Group.find(params[:id])
    @group.leave
    redirect_to group_path(@group)
  end

  # Will remove another user from the group specified, presuming the current
  # user has admin privileges for the group
  # @param id [Integer] The id of the group
  # @param user_id [Integer] The id of the group
  def kick
    @group = Group.find(params[:id])
    @target = User.find(params[:user_id])
    @target.remove_group @group
    redirect_to group_path(@group)
  end

  # Will generate a notification for admins of the group. Any admin will then be
  # able to approve the request, adding the requesting user to the group
  def join
    #NOTIFICATION NEEDED
  end

  # Will generate a notification for a user, inviting them to the group. Only
  # admins will be able to access this function
  def invite_user
    @group = Group.find(params[:id])
    user = User.find( params[:user_id] )
    if ! @group.users.include? user
      @group.users.push user
    end
    respond_to do |format|
      format.html { redirect_to group_path(@group), :flash => { :success =>'Member added successfully.' }}
    end
  end

  private

  # Will set the current group, if not already set
  # @param id [Integer]
  def group
    @group ||= Group.find(params[:id])
  end
end
