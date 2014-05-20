module GroupHelper
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

  def render_promote(user_id)
    target = User.find(user_id)
    if @group.admins.include? @user
      if !(@group.admins.include? target)
        link_to 'Promote', {:action => :promote, :id => @group.id, :user_id => user_id}, :class => 'btn btn-default', :'data-placement' => 'bottom', :title => 'Promote member to admin'
      end
    end
  end

  def render_demote(user_id)
    if @user.id==user_id&&@group.admins.include?(@user)
      link_to 'Demote', {:action => :demote, :id => @group.id, :user_id => user_id}, :class => 'btn btn-default', :'data-placement' => 'bottom', :title => 'Promote member to admin'
    end
  end

  def render_quest_count(campaign, status)
    quests = campaign.quests.find_all{|q| q.status == status}
    html = content_tag(:span,  (quests.nil?) ? 0 : quests.size, :class => 'badge')
    return html.html_safe
  end

  def render_role(group, user)
    if group.admins.include? user
      return 'Admin'
    else
      return 'Member'
    end
  end

  def render_add_member
    if @group.admins.include? @user
      link_to 'Add Member', '#add-member-modal', :class => 'btn btn-primary pull-right', :'data-placement' => 'bottom', :'data-toggle' => 'modal', :title => 'Add new members'
    end
  end

  def invite_user_path
    '/group/' + @group.id.to_s + '/invite_user'
  end
end
