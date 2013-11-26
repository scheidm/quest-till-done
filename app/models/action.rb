class Action < ActiveRecord::Base
  has_many :nodes, through: :pomodoros

end
