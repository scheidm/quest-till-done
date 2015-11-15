module GroupHelper
  def quest_count(campaign, status)
    quests = campaign.quests.find_all{|q| q.status == status}
    html = content_tag(:span,  (quests.nil?) ? 0 : quests.size, :class => 'badge')
    return html.html_safe
  end

  def role_for(group, user)
    if group.admins.include? user
      return 'Admin'
    else
      return 'Member'
    end
  end

  def invite_user_path
    '/group/' + @group.id.to_s + '/invite_user'
  end
end
