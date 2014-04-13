module GroupHelper
  def render_remove(user_id)
    if @group.admins.include? @user
      link_to 'Remove', {:action => :kick, :id => @group.id, :user_id => user_id}, :class => 'btn btn-danger', :'data-placement' => 'bottom', :title => 'Remove member from group'
    end
  end

  def render_promote(user_id)
    target = User.find(user_id)
    if @group.admins.include? @user
      if !(@group.admins.include? target)
        link_to 'Promote', "#", :remote => true, :class => 'btn btn-default', :'data-placement' => 'bottom', :'data-toggle' => 'modal', :title => 'Remove member from group'
      else
        link_to 'Promote', "#", :remote => true, :class => 'btn btn-default', :'data-placement' => 'bottom', :'data-toggle' => 'modal', :title => 'Remove member from group', 'disabled' => true
      end
    end
  end

  def render_quest_count(campaign, status)
    quests = campaign.quests.find_all{|q| q.status == status}
    html = content_tag(:span,  (quests.nil?) ? 0 : quests.size, :class => 'badge')
    return html.html_safe
  end

  def render_role(user)
    if @group.admins.include? user
      return 'Admin'
    else
      return 'Member'
    end
  end
end