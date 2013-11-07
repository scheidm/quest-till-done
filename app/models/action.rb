class Action < Node
  has_many :pomodoros
  has_many :nodes, through: :pomodoros

end
