
class NotificationsController < ApplicationController
  def group_kick
    @group = Group.find(params[:id])
    if @group.admins.include? @user
      @target = User.find( params[:user_id] )
      if @group.admins.include? @target
        #NOTIFICATION NEEDED
      else
        @group.users.delete User.find( params[:user_id] )
      end
    end
    respond_to do |format|
      format.html { redirect_to group_path(@group), notice: 'Member removed successfully.' }
    end
  end

  def group_invite
    @group = Group.find(params[:id])
    user = User.find( params[:user_id] )
    unless @group.users.include? user
      @group.users.push user
    end
    respond_to do |format|
      format.html { redirect_to group_path(@group), :flash => { :success =>'Member added successfully.' }}
    end
  end

  def group_promote
    @group = Group.find(params[:id])
    user = User.find( params[:user_id] )
    unless @group.admins.include? user
      @group.admins.push user
    end
    respond_to do |format|
      format.html { redirect_to group_path(@group), notice: 'Member promoted successfully.' }
    end
  end

end
