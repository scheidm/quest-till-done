module GroupHelper
  # Will generate button to remove specified user for the group, presuming they
  # have permissions to do so, given the current user's permissions and the
  # permissions of the target user
  # @param user_id [Integer] the id of the target user
  # @return [Html] remove member button's html
  def render_remove(user_id)
    if @group.admins.include? @user 
      if @user.id==user_id
        link_to 'Leave', {:action => :leave, :id => @group.id}, :class => 'btn btn-danger', :'data-placement' => 'bottom', :title => 'Remove member from group'
      else
        unless @group.admins.include? User.find(user_id)
          link_to 'Remove', {:action => :kick, :id => @group.id, :user_id => user_id}, :class => 'btn btn-danger', :'data-placement' => 'bottom', :title => 'Remove member from group'
        end
      end
    end
  end

  # Will generate button to promote specified user for the group, presuming they
  # have permissions to do so, given the current user's permissions and the
  # permissions of the target user
  # @param user_id [Integer] the id of the target user
  # @return [Html] promote member button's html
  def render_promote(user_id)
    target = User.find(user_id)
    if @group.admins.include? @user
      if !(@group.admins.include? target)
        link_to 'Promote', {:action => :promote, :id => @group.id, :user_id => user_id}, :class => 'btn btn-default', :'data-placement' => 'bottom', :title => 'Promote member to admin'
      end
    end
  end

  # Will generate button to demote specified user for the group, presuming they
  # have permissions to do so, given the current user's permissions and the
  # permissions of the target user
  # @param user_id [Integer] the id of the target user
  # @return [Html] demote button's html
  def render_demote(user_id)
    if @user.id==user_id&&@group.admins.include?(@user)
      link_to 'Demote', {:action => :demote, :id => @group.id, :user_id => user_id}, :class => 'btn btn-default', :'data-placement' => 'bottom', :title => 'Promote member to admin'
    end
  end

  # Will generate an icon listing the number of quests matching a current status
  # within the specified campaign
  # @param campaign [Campaign] the campaign to search
  # @param status [String] the string to search for 
  # @return [Html] quest count html
  def render_quest_count(campaign, status)
    quests = campaign.quests.find_all{|q| q.status == status}
    html = content_tag(:span,  (quests.nil?) ? 0 : quests.size, :class => 'badge')
    return html.html_safe
  end

  # Will generate the role text based on the QTD group membership type for the
  # user
  # @param group [Group] the group in question
  # @param use [User] the user in question
  # @return [Html] render member role html
  def render_role(group, user)
    if group.admins.include? user
      return 'Admin'
    else
      return 'Member'
    end
  end

  # Will generate button to add a user to the group, presuming they
  # have permissions to do so, given the current user's permissions and the
  # permissions of the target user
  # @return [Html] add member button's html
  def render_add_member
    if @group.admins.include? @user
      link_to 'Add Member', '#add-member-modal', :class => 'btn btn-primary pull-right', :'data-placement' => 'bottom', :'data-toggle' => 'modal', :title => 'Add new members'
    end
  end

  # Will return a path to the current group, with the invite_user action
  # @return [String] url to invite user
  def invite_user_path
    '/group/' + @group.id.to_s + '/invite_user'
  end
end
