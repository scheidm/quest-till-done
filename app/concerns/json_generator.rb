# Module for Generating JSON for displaying with Javascript
module JsonGenerator
  # Module for Encounter
  module EncounterModule
    # Generate a tree JSON for a user's encounter
    # @param user [User] User to generate encounter JSON for
    # @return [JSON] JSON formatted data
    def generateTree(encounters, campaign_id)
      data = []
      format = '%I:%M%p'
      data_by_date = {}
      encounters.each do |encounter|
        end_time = (encounter.end_time.nil? ) ? 'Now' : encounter.end_time.strftime(format)
        encounter_data = {:data => encounter.created_at.strftime(format) + ' to ' + end_time, :attr => { :rel => 'round', :href => 'javascript:void(0)'} }
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
  end

  # Module for Quest and Campaigns
  module QuestModule
    # Generate a Campaign tree JSON for a campaign
    # @param campaign [Campaign] Campaign to generate JSON for
    # @return [JSON] JSON formatted tree data
    def generateCampaignTree (campaign)
      if (!campaign.is_a?(Campaign))
        raise 'Expected argument to be a campaign'
      end
      data = {:id => campaign.id, :attr => { :name => campaign.name, :description => campaign.description, :url => '/campaigns/' + campaign.id.to_s}}
      data[:children] = children = []
      campaign.quests.each {|quest|
        children << generateChildTree(quest) if quest.status=="Open"
      }

      return data.to_json
    end

    # Generate a Quest tree JSON for a quest
    # @param quest [Quest] Quest to generate JSON
    # @return [JSON] JSON formatted tree data
    def generateQuestTree (quest)
      if (!quest.is_a?(Quest))
        raise 'Expected argument to be a campaign'
      end
      data = generateChildTree(quest)

      return data.to_json
    end

    # Recursive function to generate json for all quest underneath a quest
    # @param quest [Quest] Quest to generate JSON
    # @return [JSON] JSON formatted tree data
    def generateChildTree(quest)

      data = {:id => quest.id, :attr => { :name => quest.name, :description => quest.description, :url => '/quests/' + quest.id.to_s}}
      if(quest.quests.size == 0)
         return data
      else
        data[:children] = children = []
        quest.quests.each {|quest|
          children << generateChildTree(quest)
        }
      end
      return data
    end
  end
end
