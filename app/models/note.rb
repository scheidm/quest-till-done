class Note < ActiveRecord::Base
  attr_accessor :pomodoro
  belongs_to :pomodoro
  validates_associated :pomodoro
  validates_presence_of :description, :allow_blank => false
end
