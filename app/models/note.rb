class Note < ActiveRecord::Base
  acts_as_heir_of :node
  attr_accessor :pomodoro
  belongs_to :pomodoro
  validates_associated :pomodoro
  validates_presence_of :description, :allow_blank => false
end
