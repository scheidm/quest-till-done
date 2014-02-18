# Module for Generating JSON for displaying with Javascript
module JsonGenerator
  # Module for Encounter
  module EncounterModule
    # Generate a tree JSON for a user's encounter
    # @param user [User] User to generate encounter JSON for
    # @return [JSON] JSON formatted data
    def generateTree
      @encounters = Encounter.all
      data = []

      @encounters.each {|item|
        _endTime = item.end_time
        _endTime = (item.end_time.nil? ) ? 'Now' : item.end_time.to_formatted_s(:long)
        @TreeData = ({:data => item.created_at.to_formatted_s(:long) + ' - ' + _endTime, :attr => { :href => '/encounters/' + item.id.to_s, :rel => 'encounters' }})
        @TreeData[:children] = children = []
        item.nodes.each {|node|
          type = node.specific
          children <<  ({:data => type.description, :attr => { :href => '/'+ type.class.name.downcase + 's/' + type.id.to_s, :rel => type.class.name }})
        }
        data.push(@TreeData)
      }
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
