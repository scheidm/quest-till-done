class Action < ActiveRecord::Base
  has_many :records, through: :pomodoros

end
