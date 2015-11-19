# Controller for Priority
class PrioritiesController < ApplicationController

  def index
    @campaigns = @user.total_campaigns.order('name ASC')
  end

  def get_priorities
    @campaign = Campaign.find(params[:id])
    quests = @campaign.all_quests.where.not( :status => 'Closed')
    important_quests = quests.where( :importance => true).order('deadline ASC').limit(25) 
    expiring_quests = quests.where( "deadline < ?", 30.days.from_now ).where( :importance => false).order('deadline ASC').limit(25) 
    data=prep_return(important_quests, expiring_quests)
    render :text => data.to_json
  end

  def get_all_priorities
    quests = @user.total_quests.where.not( :status => 'Closed')
    important_quests = quests.where( :importance => true).order('deadline ASC').limit(25) 
    expiring_quests = quests.where( "deadline < ?", 30.days.from_now ).where( :importance => false).order('deadline ASC').limit(25) 
    data=prep_return(important_quests, expiring_quests)
    render :text => data.to_json
  end
#private
  def prep_return(iqs, eqs)
    c_ids={}
    iqs.each do |i|
      c_ids[i.campaign_id]=1
    end
    eqs.each do |i|
      c_ids[i.campaign_id]=1
    end
    c_ids.tap { |hs| hs.delete(nil) }
    campaigns=Campaign.where('id IN (?)', c_ids.keys).pluck(:id,:name)
    campaign_hash={}
    campaigns.each do |c|
      campaign_hash[c[0]]=c[1]
    end
    data = []
    data.push(iqs)
    data.push(eqs)
    data.push(campaign_hash)
    return data
  end
end
