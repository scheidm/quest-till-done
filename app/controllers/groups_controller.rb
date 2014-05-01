# Controller for the group page
class GroupsController < ApplicationController
  power :crud => :groups

  include JsonGenerator::TimelineModule
  
  # Display a list of all groups for the current user
  def index
    @member_groups = @user.groups_where_member
    @admin_groups = @user.groups_where_admin
  end

  # Display the group page for the specified group, presuming the user has
  # access rights granted to them.
  def show
    @group = Group.find(params[:id])
  redirect_to groups_path, :flash => { :warning =>"Permission Denied"}\
    unless current_power.group? @group
  end

  def group_params
    params.require(:group).permit(:id, :name)
  end

  def new
    @group = Group.new()
  end

  def create
    @group = Group.new(group_params)
    respond_to do |format|
      if @group.save
        @group.admins.push @user
        @group.users.push @user
        format.html { redirect_to group_path(@group), notice: 'Group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @quest.campaign }
        @user.send_message(@user, 'You created a new group! Start adding members from your group page!', 'New Group Created')
      else
        format.html { render action: 'new'}
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def leave
    @group = Group.find(params[:id])
    @group.leave @user
    respond_to do |format|
      format.html { redirect_to groups_path, :flash => { :success =>"Left group #{@group.name}" }}
      @user.send_message(@user, "You left a group!", "You left group #{@group.name}")
    end

  end

  def kick
    @group = Group.find(params[:id])
    @target = User.find(params[:user_id])
    @group.leave @target unless @group.admins.include? @target
    respond_to do |format|
      format.html { redirect_to group_path(@group), :flash => { :success =>"Removed member #{@target.username}" }}
      @user.send(@target, "You have been kick from group #{@group.name}", "You no longer have access to #{@group.name} ")
    end
  end

  def promote
    @group = Group.find(params[:id])
    @target = User.find(params[:user_id])
    @target.promote_in_group @group
    respond_to do |format|
      format.html { redirect_to group_path(@group), :flash => { :success =>"Promoted member #{@target.username}" }}
      @user.send_message(@target, "You have been promoted in group #{@group.name}", "Check you new privileges at group #{@group.name}")
    end
  end

  def demote
    @group = Group.find(params[:id])
    @target = User.find(params[:user_id])
    @group.demote @target
    respond_to do |format|
      format.html { redirect_to group_path(@group), :flash => { :success =>"Demoted member #{@target.username}" }}
      @user.send_message(@target, "You have been demoted from group: #{@group.name}", "Your privileges have been demoted by yourself")
    end
  end

  def join
    #NOTIFICATION NEEDED
  end

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

  def accept_user
    #NOTIFICATION NEEDED
  end

  def timeline
    @group = Group.find(params[:id])
    render :text => generateTimeline(@group.rounds.limit(100))
  end

  private

  def group
    @group ||= Group.find(params[:id])
  end
end
