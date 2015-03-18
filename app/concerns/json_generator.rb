# Module for Generating JSON for displaying with Javascript
module JsonGenerator
  module TimelineModule
    include ActionView::Helpers::DateHelper
    def generateTimeline(rounds)
      format = '%I:%M%p'
      data = []
      rounds.each do |round|
        data << {:id => round.event_id, :data => "#{trunc(round.event_description)} #{round.type}: #{round.related_obj.to_s} - #{round.created_at.to_time.strftime(format) } ago", :attr => { :rel => round.type, :href => round.related_link }}
      end
      return data.to_json
    end
  end

  # Module for Encounter
  module EncounterModule
    include ActionView::Helpers::DateHelper
    # Generate a tree JSON for a campaign's round
    # @param rounds [Round] Rounds to generate tree
    # @return [JSON] JSON formatted data
    def generateTree(encounters, campaign_id)
      format = '%I:%M%p'
      data = []
      data_by_date = {}
      encounters.each do |encounter|
        end_time = (encounter.end_time.nil? ) ? 'Now' : encounter.end_time.to_time.strftime(format)
        encounter_data = {:data => encounter.created_at.to_time.strftime(format) + ' to ' + end_time, :attr => { :rel => 'round', :href => 'javascript:void(0)'} }
        encounter_data[:children] = children = []
        encounter.rounds.each {|round|
          if campaign_id.nil? || round.campaign_id == campaign_id.to_i
            children << {:id => round.event_id, :data => round.event_description + ' ' + round.type+": "+round.related_obj.to_s, :attr => { :rel => round.type, :href => round.related_link }}
          end
        }
        data_by_date[encounter.created_at.to_date] ||= Array.new
        if encounter_data[:children].size > 0
          data_by_date[encounter.created_at.to_date].push(encounter_data)
        end
      end
      data_by_date.each do |key, value|
        temp = {:data => key, :attr => { :rel => 'encounter', :href => 'javascript:void(0)'}}
        temp[:children] = value
        data.push(temp)
      end
      return data.to_json
    end

    # Generate a tree JSON for a user's encounter
    # @param encounters [Encounter] User to generate encounter JSON for
    # @return [JSON] JSON formatted data
    def generateUserTree(encounters, campaign_id)
      data = []
      format = '%I:%M%p'
      data_by_date = {}
      encounters.each do |encounter|
        end_time = (encounter.end_time.nil? ) ? 'Now' : encounter.end_time.to_time.strftime(format)
        encounter_data = {:data => encounter.created_at.to_time.strftime(format) + ' to ' + end_time, :attr => { :rel => 'round', :href => 'javascript:void(0)'} }
        encounter_data[:children] = children = []
        encounter.rounds.order(created_at: :desc).each {|round|
          if campaign_id.nil? || round.campaign_id == campaign_id.to_i
            children << {:id => round.event_id, :data => "#{round.event_description} #{round.type}: #{round.related_obj.to_s} - #{time_ago_in_words(round.created_at )} ago", :attr => { :rel => round.type, :href => round.related_link }}
          end
        }
        data_by_date[encounter.created_at.to_date] ||= Array.new
        if encounter_data[:children].size > 0
          data_by_date[encounter.created_at.to_date].push(encounter_data)
        end
      end
      data_by_date.each do |key, value|
        temp = {:data => key, :attr => { :rel => 'encounter', :href => 'javascript:void(0)'}}
        temp[:children] = value
        data.push(temp)
      end
      return data.to_json
    end
  end

  # Module for Quest and Campaigns
  module QuestModule
    # Generate a JSON for all campaigns
    # @param campaign [Campaign] Campaign to generate JSON for
    # @return [JSON] JSON formatted tree data
    def generateTDJSON(user)
      data = {:id => 0, :attr => { :name => "World View", :description => "World View", :url => '#'}}
      data[:children] = children = []
      user.groups.each {|group|
        group_data = {:id => "group_#{group.id}", :attr => { :name => group.name, :description => group.name, :url => '#'}}
        group_data[:children] = group_children = []
        group.campaigns.each {|campaigns|
          group_children << generateTDQuestJSON2(campaigns)
        }
        children << group_data
      }

      return data.to_json
    end

    def generateTDQuestJSON(campaign)
      data = {:id => campaign.id, :attr => { :name => campaign.name, :description => campaign.description, :url => '/campaigns/' + campaign.id.to_s, :status => campaign.status, :color => '#c6dbef'}}
      data[:children] = children = []
      campaign.quests.each {|quest|
        color = '#29AB87'
        radius = 45;
        if quest.importance then
          color = '#0A6F75'
          radius = 60;
        end
        if (!quest.deadline.nil? && quest.deadline < 7.days.from_now) then
          color = '#AF4D43'
          radius = 45 + 40/7;
        end

        children << {:id => quest.id, :attr => { :name => quest.name, :description => quest.description, :url => '/quests/' + quest.id.to_s, :status => quest.status, :color => color, :radius => radius}}
      }
      return data
    end

    def generateTDQuestJSON2(campaign)
      number_of_days = 7
      data = nil
      0.upto(number_of_days) {|number|
        ring = {:id => "#{number}_days_#{campaign.id}"}
        ring[:children] = children = []
        if !data.nil?
          children << data
        else
          children << {:id => nil, :attr => { :name => campaign.name, :description => campaign.description, :url => '/campaigns/' + campaign.id.to_s, :status => campaign.status, :color => '#AF4D43'}}
        end
        if number != 0
          count = 0
          campaign.quests.where("deadline >= ? and deadline < ?", (number-1).days.from_now, number.days.from_now).each {|quest|
            color = '#29AB87'
            radius = 45;
            if quest.importance then
              color = '#0A6F75'
              radius = 60;
            end
            children << {:id => quest.id, :attr => { :name => quest.name, :description => quest.description, :url => '/quests/' + quest.id.to_s, :status => quest.status, :color => color, :radius => radius}}
            count+=1
          }
          ring[:attr] = {:name => "#{number} Days", :description => "#{count} quests pending", :url => '#'}
        else
          ring[:attr] = {:name => "Campaign", :description => campaign.description, :url => '#'}
        end
        data = ring
      }
      return data
    end

    # Generate a Campaign tree JSON for a campaign
    # @param campaign [Campaign] Campaign to generate JSON for
    # @return [JSON] JSON formatted tree data
    def generateCampaignTree (campaign, only_active)
      if (!campaign.is_a?(Campaign))
        raise 'Expected argument to be a campaign'
      end
      data = {:id => campaign.id, :attr => { :name => campaign.name, :description => campaign.description, :url => '/campaigns/' + campaign.id.to_s, :status => campaign.status}}
      data[:children] = children = []
      campaign.child_quests.each {|quest|
        children << generateChildTree(quest,only_active) unless only_active&&quest.status=="Closed"
      }

      return data.to_json
    end

    # Generate a Quest tree JSON for a quest
    # @param quest [Quest] Quest to generate JSON
    # @return [JSON] JSON formatted tree data
    def generateQuestTree (quest, only_active)
      if (!quest.is_a?(Quest))
        raise 'Expected argument to be a campaign'
      end
      data = generateChildTree(quest, only_active)

      return data.to_json
    end

    # Recursive function to generate json for all quest underneath a quest
    # @param quest [Quest] Quest to generate JSON
    # @return [JSON] JSON formatted tree data
    def generateChildTree(quest, only_active)

      data = {:id => quest.id, :attr => { :name => quest.name, :description => quest.description, :url => '/quests/' + quest.id.to_s, :status => quest.status}}
      if(quest.child_quests.size == 0)
         return data
      else
        data[:children] = children = []
        quest.child_quests.each {|q|
          children << generateChildTree(q, only_active) unless only_active&&q.status=="Closed"
        }
      end
      return data
    end
  end
end
