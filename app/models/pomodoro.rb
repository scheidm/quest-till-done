class Pomodoro < ActiveRecord::Base
  has_many :tags
  has_many :nodes
end
