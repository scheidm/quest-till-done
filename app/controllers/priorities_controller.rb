# Controller for Priority
class PrioritiesController < ApplicationController

  def index
    @campaigns = @user.total_campaigns.order('name ASC')
  end

  def get_priorities
    @campaign = Campaign.find(params[:id])
    quests = @campaign.all_quests.where.not( :status => 'Closed')
    @important_quests = quests.where( :importance => true).order('deadline ASC').limit(25) 
    @expiring_quests = quests.where( "deadline < ?", 30.days.from_now ).order('deadline ASC').limit(25) 
    data = []
    data.push(@important_quests)
    data.push(@expiring_quests)
    render :text => data.to_json
  end

  def get_all_priorities
    quests = @user.total_quests.where.not( :status => 'Closed')
    important_quests = quests.where( :importance => true).order('deadline ASC').limit(25) 
    expiring_quests = quests.where( "deadline < ?", 30.days.from_now ).order('deadline ASC').limit(25)
    data = []
    data.push(important_quests)
    data.push(expiring_quests)
    render :text => data.to_json
  end
end
