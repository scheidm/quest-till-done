# Module for Generating JSON for displaying with Javascript
module JsonGenerator
  # Module for Encounter
  module EncounterModule
    include ActionView::Helpers::DateHelper
    # Generate a tree JSON for a user's encounter
    # @param user [User] User to generate encounter JSON for
    # @return [JSON] JSON formatted data
    def generateTree(rounds, campaign_id)
      data = []
      format = '%I:%M%p'
      rounds.each do |round|
        data << {:id => round.event_id, :data => "#{round.event_description} #{round.type}: #{round.related_obj.to_s} - #{distance_of_time_in_words(round.created_at.strftime(format), Time.now)} ago", :attr => { :rel => round.type, :href => round.related_link }}
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
      data = {:id => campaign.id, :attr => { :name => campaign.name, :description => campaign.description, :url => '/campaigns/' + campaign.id.to_s, :status => campaign.status}}
      data[:children] = children = []
      campaign.quests.each {|quest|
        children << generateChildTree(quest)
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

      data = {:id => quest.id, :attr => { :name => quest.name, :description => quest.description, :url => '/quests/' + quest.id.to_s, :status => quest.status}}
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
