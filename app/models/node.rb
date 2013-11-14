class Node < ActiveRecord::Base
  acts_as_predecessor
  attr_accessor :pomodoro
  belongs_to :pomodoro
  validates_associated :pomodoro
end
