# Model representing a single user's current skill level, as determined by their
# completion of tasks tagged with the given skill
class SkillPoint < ActiveRecord::Base
  belongs_to :user
  belongs_to :skill

  def initialize


  end


end
