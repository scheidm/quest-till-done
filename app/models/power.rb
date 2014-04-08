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


end
