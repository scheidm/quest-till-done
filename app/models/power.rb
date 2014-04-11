class Power
  include Consul::Power

  def initialize(user)
    @user = user
  end


  power :campaigns, :creatable_campaigns, :updatable_campaigns  do
    Campaign.where( 'group_id in (?) ', @user.groups.pluck(:id))
  end

  power :destroyable_campaigns do
    Campaign.where( 'group_id in (?)', @user.groups_where_admin.pluck(:id))
  end

  power :quests, :creatable_quests, :updatable_quests  do
    Quest.where( 'group_id in (?) ', @user.groups.pluck(:id))
  end

  power :destroyable_quests do
    Quest.where( 'group_id in (?)', @user.groups_where_admin.pluck(:id))
  end

  power :records, :creatable_records do
    Records.where( 'group_id in (?)', @user.groups.pluck(:id))
  end

  power :updatable_records, :destroyable_records do
    Records.where( 'group_id in (?)', @user.groups_where_admin.pluck(:id))
  end

  power :groups, :creatable_groups do
    Groups.where( 'group_id in (?)', @user.groups.pluck(:id))
  end

  power :updatable_groups, :destroyable_groups do
    Groups.where( 'group_id in (?)', @user.groups_where_admin.pluck(:id))
  end

end
