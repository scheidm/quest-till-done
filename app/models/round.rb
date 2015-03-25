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
  include ActionView::Helpers::DateHelper
  include ApplicationHelper

  def self.create_event(model, operation, campaign)
    raise ArgumentError, 'campaign id is nil' if campaign.id.nil?
    raise ArgumentError, 'operation is empty' if operation.empty?
    round = Round.new
    round.encounter = Encounter.last
    type= model.class.name.demodulize
    if operation=="destroy"
      round.event_id = campaign.id
      round.event_description = "A #{type.downcase} named #{model.name} was destroyed"
    else
      if(model.id.nil?)
        model.reload
      end
      round.event_id = model.id
      round.event_description = operation.gsub("_"," ")
    end
    round.type = type
    round.campaign_id = campaign.id
    round.group=campaign.group
    round.save
  end

  def related_obj
    self.type.singularize.classify.constantize.find(self.event_id)
  end

  def related_link
    self.related_obj.to_link
  end

  def to_str(length = 125)
    format = '%I:%M%p'
    return "#{trunc(self.event_description, length)} #{self.type}: #{trunc(self.related_obj.to_s,length)} - #{self.created_at.to_time.strftime(format)}"
  end
end
