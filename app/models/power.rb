class Power
  #This class will define the permissions a user will have based on their group
  #relations
  include Consul::Power

  def initialize(user)
    @user = user
  end


  #A user will be able to create, update and view any campaign in their groups
  power :campaigns, :creatable_campaigns, :updatable_campaigns  do
    Campaign.where( 'group_id in (?) ', @user.groups.pluck(:id))
  end

  #A user will be able to destroy any campaign they are an administrator over
  power :destroyable_campaigns do
    Campaign.where( 'group_id in (?)', @user.groups_where_admin_and_wrapper.pluck(:id))
  end

  #A user will be able to create, update and view any quest in their groups
  power :quests, :creatable_quests, :updatable_quests  do
    Quest.where( 'group_id in (?) ', @user.groups.pluck(:id))
  end

  #A user will be able to destroy any quest they are an administrator over
  power :destroyable_quests do
    Quest.where( 'group_id in (?)', @user.groups_where_admin_and_wrapper.pluck(:id))
  end

  #A user will be able to create and view records related to any group they are
  #part of
  power :records, :creatable_records do
    Record.where( 'group_id in (?)', @user.groups.pluck(:id))
  end

  #A user will be able to destroy records related to any group they are an
  #administrator over
  power :destroyable_records do
    Record.where( 'group_id in (?)', @user.groups_where_admin_and_wrapper.pluck(:id))
  end

  #A user will be able to update records they create
  power :updatable_records do
    Record.where( 'encounter_id in (?)', @user.encounters.limit(100) )
  end


  #A user will be able to view, create, and leave groups they are part of
  power :groups, :creatable_groups, :leave_groups do
    @user.groups_less_wrapper
  end
  
  #A user will be able to update and destroy any campaign they are an administrator over
  power :updatable_groups, :destroyable_groups do
    user.groups_where_admin_and_wrapper
  end
end
