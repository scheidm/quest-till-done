module JsonGenerator
  module EncounterModule
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

  module QuestModule
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
    def generateQuestTree (quest)
      if (!quest.is_a?(Quest))
        raise 'Expected argument to be a campaign'
      end
      data = generateChildTree(quest)

      return data.to_json
    end


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
