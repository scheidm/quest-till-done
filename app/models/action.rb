class Action < ActiveRecord::Base
  has_many :nodes, through: :pomodoros
  has_many :actions
  def is_task?
    self.actions.nil?
  end
  
  def is_top_lvl_project?
    self.parent_id.nil?
  end
end
