##
# Round stores a single action in an encounter, for exp tracking
# and timeline display purposes. Using STI, the model stores a related
# quest, campaign, skill_point, or group to store the related ActiveRecord 
# object
class Round < ActiveRecord::Base
  belongs_to :encounter
  belongs_to :campaign
end
