# Controller for Priority
class PrioritiesController < ApplicationController

  def index
    @campaigns = @user.total_campaigns.order('name ASC')
  end

  def get_priorities
    @campaign = Campaign.find(params[:id])
    quests = @campaign.all_quests.where.not( :status => 'Closed')
    data=prioritize(quests)
    render :text => data.to_json
  end

  def get_all_priorities
    quests = @user.total_quests.where.not( :status => 'Closed')
    data=prioritize(quests)
    render :text => data.to_json
  end
#private
  def prioritize(quests)
    c=quests.where('quests.updated_at < (?)', 1.month.ago).where.not(:campaign_id => nil).count   
    c=2 if c<2
    stale_quests = quests.where('quests.updated_at < (?)', 1.month.ago).where.not(:campaign_id => nil).limit(2).offset(rand(c-2))
    important_expiring_quests = quests.where( "deadline < (?)", 14.days.from_now ).where( :importance => true).order('deadline ASC').limit(10) 
    expiring_quests = quests.where( "deadline < (?)", 14.days.from_now ).where( :importance => false).order('deadline ASC').limit(10)
    c=quests.where(:importance => true ).where(:deadline => nil).count
    c=10 if c<2
    important_quests=quests.where(:importance => true ).where(:deadline => nil).limit(10).offset(rand(c-10))
    return prep_return(stale_quests, important_expiring_quests, expiring_quests, important_quests )
  end
  def prep_return(sqs, ieqs, eqs, iqs)
    c_ids={}
    sqs.each do |i|
      c_ids[i.campaign_id]=1
    end
    ieqs.each do |i|
      c_ids[i.campaign_id]=1
    end
    eqs.each do |i|
      c_ids[i.campaign_id]=1
    end
    iqs.each do |i|
      c_ids[i.campaign_id]=1
    end
    c_ids.tap { |hs| hs.delete(nil) }
    campaigns=Campaign.where('id IN (?)', c_ids.keys).pluck(:id,:name)
    campaign_hash={}
    campaigns.each do |c|
      campaign_hash[c[0]]=c[1]
    end
    data = []
    data.push(sqs)
    data.push(ieqs)
    data.push(eqs)
    data.push(iqs)
    data.push(campaign_hash)
    return data
  end
end
