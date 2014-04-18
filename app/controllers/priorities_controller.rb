# Controller for Priority
class PrioritiesController < ApplicationController

  def index
    @campaigns = Campaign.where( :group_id =>  @user.wrapper_group.id)
  end

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

  def get_all_priorities
    campaigns = @user.campaigns
    data = []
    campaigns.each do |campaign|
      quests = campaign.all_quests.where.not( :status => 'Closed')
      @importance_quests = quests.where( :importance => true)
      @expiring_quests = quests.where( "deadline < ?", 7.days.from_now ).order('deadline DESC')
      data.push(@importance_quests)
      data.push(@expiring_quests)
    end
    render :text => data.to_json
  end
end
