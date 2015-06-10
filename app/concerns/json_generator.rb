# Module for Generating JSON for displaying with Javascript
module JsonGenerator
  module TimelineModule
    include ActionView::Helpers::DateHelper
    def generateTimeline(rounds)
      data = []
      rounds.each do |round|
        data << round.to_json
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
      data_by_date = {}
      encounters.each do |encounter|
        encounter_data=encounter.to_json
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
    include ApplicationHelper
    # Generate a JSON for all campaigns
    # @param campaign [Campaign] Campaign to generate JSON for
    # @return [JSON] JSON formatted tree data
    def generateTDJSON(user)
      data = {:id => 0, :attr => { :name => "World View", :description => "World View", :url => '#'}}
      data[:children] = children = []
      user.groups.each {|group|
        children << group.to_td_json
      }
      return data.to_json
    end


    # Generate a Campaign tree JSON for a campaign
    # @param campaign [Campaign] Campaign to generate JSON for
    # @return [JSON] JSON formatted tree data
    def generateCampaignTree (campaign, only_active)
      if (!campaign.is_a?(Campaign))
        raise 'Expected argument to be a campaign'
      end
      data = campaign.to_json
      data[:children] = children = []
      campaign.child_quests.each {|quest|
        children << quest.to_tree_json(only_active) unless only_active&&quest.status=="Closed"
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
      data = quest.to_tree_json(only_active)

      return data.to_json
    end

  end
end
