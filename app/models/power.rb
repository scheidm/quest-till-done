class Power
  include Consul::Power

  def initialize(user)
    @user = user
  end


  power :campaigns, :creatable_campaigns, :updatable_campaigns  do
    Campaign.where( 'group_id in (?) ', @user.groups.pluck(:id))
  end

  power :destroyable_campaigns do
    Campaign.where( 'group_id in (?)', @user.groups_where_admin_and_wrapper.pluck(:id))
  end

  power :quests, :creatable_quests, :updatable_quests  do
    Quest.where( 'group_id in (?) ', @user.groups.pluck(:id))
  end

  power :destroyable_quests do
    Quest.where( 'group_id in (?)', @user.groups_where_admin_and_wrapper.pluck(:id))
  end

  power :records, :creatable_records do
    Record.where( 'group_id in (?)', @user.groups.pluck(:id))
  end

  power :destroyable_records do
    Record.where( 'group_id in (?)', @user.groups_where_admin_and_wrapper.pluck(:id))
  end

  power :updatable_records do
    Record.where( 'encounter_id in (?)', @user.encounters.limit(100) )
  end

  power :groups, :creatable_groups, :leave_groups do
    @user.groups_less_wrapper
  end
  
  power :updatable_groups, :destroyable_groups do
    user.groups_where_admin_and_wrapper
  end
end
