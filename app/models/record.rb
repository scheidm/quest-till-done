class Record < ActiveRecord::Base
  attr_accessor :pomodoro
  belongs_to :pomodoro
  validates_associated :pomodoro
end
