##
# Round stores a single action in an encounter, for exp tracking
# and timeline display purposes. Using STI, the model stores a related
# quest, campaign, skill_point, or group to store the related ActiveRecord 
# object
class Round < ActiveRecord::Base
  belongs_to :encounter
  belongs_to :campaign
  belongs_to :group
  self.inheritance_column = nil

  #Will record the event processed by the controller as a round, for later
  #display in a timeline.
  #@param model [ActiveRecord::Base] the object being operated on
  #@param operation [String] the controller operation being performed
  #@param campaign [Campaign] the campaign related to the event, if any
  def self.create_event(model, operation, campaign)
    raise ArgumentError, 'campaign id is nil' if campaign.id.nil?
    raise ArgumentError, 'operation is empty' if operation.empty?
    round = Round.new
    round.encounter = Encounter.last
    if(model.id.nil?)
      model.reload
    end
    round.campaign_id = campaign.id
    round.group=campaign.group
    round.event_id = model.id
    round.type = model.class.name.demodulize
    round.event_description = operation.gsub("_"," ")
    round.save
  end

  #Will restore the original object passed in as model in create event
  def related_obj
    self.type.singularize.classify.constantize.find(self.event_id)
  end

  #Will return the link for the original object
  def related_link
    self.related_obj.to_link
  end
end
