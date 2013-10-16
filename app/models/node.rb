class Node < ActiveRecord::Base
  belongs_to :pomodoro
  has_many :tags
end
