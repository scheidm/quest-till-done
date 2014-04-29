# Controller for Priority
class PrioritiesController < ApplicationController

  # Will show all quests with an upcoming deadline, or makred important
  # @return [Html] the index page for a list of priority quests
  def index
    @campaigns = Campaign.where( :group_id =>  @user.wrapper_group.id)
  end

  # Will define priority items for the given user for display on index
  def get_priorities
    @campaign = Campaign.find(params[:id])
    quests = @campaign.all_quests.where.not( :status => 'Closed')
    @importance_quests = quests.where( :importance => true)
    @expiring_quests = quests.where( "deadline < ?", 7.days.from_now ).order('deadline DESC')
    data = []
    data.push(@importance_quests)
    data.push(@expiring_quests)
    render :text => data.to_json
  end
end
