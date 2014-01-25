class Action < ActiveRecord::Base
  has_many :records, through: :encounters
  STATES = ["Unstarted", "In Progress", "Completed"]
  validates_inclusion_of :status, :in => STATES
  validates_presence_of :name
  has_many :nodes, through: :pomodoros
  has_many :actions
  def is_task?
    !self.actions.empty?
  end
  
  def is_top_lvl_project?
    self.parent_id.nil?
  end
end
