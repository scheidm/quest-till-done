##
# Round stores a single action in an encounter, for exp tracking
# and timeline display purposes
class Round < ActiveRecord::Base
  belongs_to :encounter
  belongs_to :campaign
end
