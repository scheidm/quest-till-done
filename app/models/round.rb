##
# Round stores a single action in an encounter, for exp tracking
# and timeline display purposes. Using STI, the model stores a related
# quest, campaign, skill_point, or group to store the related ActiveRecord 
# object
class Round < ActiveRecord::Base
  belongs_to :encounter
  belongs_to :campaign
  self.inheritance_column = nil

  def self.create_event(model, operation, campaign)
    round = Round.new
    round.encounter = Encounter.last
    if(model.id.nil?)
      model.reload
    end
    round.campaign_id = campaign.id
    round.event_id = model.id
    round.type = model.class.name.demodulize
    round.event_description = operation
    round.save
  end

  def related_obj
    x={ 
      "Record" => lambda{ |id| Record.find(id)},
      "Campaign" => lambda{ |id| Campaign.find(id)},
      "Quest" => lambda{ |id| Quest.find(id)}
    }
    x[self.type].call(self.event_id)
  end

  def related_link
    if self.type=="Record"
      "quests/#{self.related_obj.quest_id}"
    else
      x={ 
        "Campaign" => "campaigns/#{self.event_id}",
        "Quest" => "quests/#{self.event_id}"
      }
      x[self.type]
    end
  end
end
