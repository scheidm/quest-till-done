# A class that establishes a manipulable list of friends for a given user, for
# display in their profile
class Friend < ActiveRecord::Base
  belongs_to :user


end
