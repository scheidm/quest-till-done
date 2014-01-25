class Record < ActiveRecord::Base
  attr_accessor :pomodoro
  belongs_to :pomodoro
  validates_associated :pomodoro

  scope :link, ->{where(type: "Link")}
  scope :note, ->{where(type: "Note")}
end
