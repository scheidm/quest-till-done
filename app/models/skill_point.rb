# Skill Point class
class SkillPoint < ActiveRecord::Base
  belongs_to :user
  belongs_to :skill

  def initialize


  end


end
