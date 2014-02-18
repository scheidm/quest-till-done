##
# Round stores a single action in an encounter, for exp and 
class Round < ActiveRecord::Base
  belongs_to :encounter
end
